# db/seeds.rb

# ====== Create Puzzle records ======
puzzles = [
  {
    question: "Ruby or Rails provided this method? Array.new(5) { |i| i * 2 }",
    answer: :ruby,
    explanation: "`Array.new` is a core Ruby method that creates a new array with a specified size and optional block for initialization. This is part of Ruby’s core library."
  },
  {
    question: "Ruby or Rails provided this method? File.open('log.txt', 'w') { |file| file.write('Hello, World!') }",
    answer: :ruby,
    explanation: "`File.open` is a core Ruby method for opening files. It’s part of Ruby's standard library for file handling, not part of Rails."
  },
  {
    question: "Ruby or Rails provided this method? render json: @user",
    answer: :rails,
    explanation: "`render json:` is a Rails method used to render a JSON response from a controller action."
  },
  {
    question: "Ruby or Rails provided this method? link_to 'Home', root_path",
    answer: :rails,
    explanation: "`link_to` is a Rails helper method that generates HTML links. `root_path` is a Rails path helper."
  },
  {
    question: "Ruby or Rails provided this method? params[:id]",
    answer: :rails,
    explanation: "`params[:id]` is used in Rails to fetch query parameters or URL parameters in controller actions."
  }
]

puzzles.each do |p|
  Puzzle.find_or_create_by!(question: p[:question]) do |puzzle|
    puzzle.answer = p[:answer]
    puzzle.explanation = p[:explanation]
  end
end

# ====== Create Archived (already sent) Puzzle records ======
# Each puzzle has a fixed success_rate (% of 10 users who answer correctly).
# Rates <= 80 appear in the "low success rate" filter; rates > 80 do not.
archived_puzzles = [
  {
    question: "Ruby or Rails provided this method? before_action :authenticate_user!",
    answer: :rails,
    explanation: "`before_action` is a Rails callback defined in `ActionController::Callbacks`. It runs specified methods before controller actions.",
    sent_at: 7.days.ago,
    success_rate: 20
  },
  {
    question: "Ruby or Rails provided this method? 42.times { puts 'hello' }",
    answer: :ruby,
    explanation: "`Integer#times` is a core Ruby method that iterates a block a specified number of times.",
    sent_at: 6.days.ago,
    success_rate: 40
  },
  {
    question: "Ruby or Rails provided this method? User.where(active: true).order(:name)",
    answer: :rails,
    explanation: "`where` and `order` are ActiveRecord query methods provided by Rails to build SQL queries.",
    sent_at: 5.days.ago,
    success_rate: 50
  },
  {
    question: "Ruby or Rails provided this method? 'hello world'.split(' ')",
    answer: :ruby,
    explanation: "`String#split` is a core Ruby method that divides a string into an array based on a delimiter.",
    sent_at: 4.days.ago,
    success_rate: 70
  },
  {
    question: "Ruby or Rails provided this method? flash[:notice] = 'Saved!'",
    answer: :rails,
    explanation: "`flash` is a Rails feature provided by `ActionDispatch::Flash` for passing messages between requests.",
    sent_at: 3.days.ago,
    success_rate: 80
  },
  # high success rate puzzles -- should NOT appear in the low success rate filter (rate > 80)
  {
    question: "Ruby or Rails provided this method? [1, 2, 3].reduce(:+)",
    answer: :ruby,
    explanation: "`Enumerable#reduce` (also `inject`) is a core Ruby method that combines elements using a binary operation.",
    sent_at: 2.days.ago,
    success_rate: 90
  },
  {
    question: "Ruby or Rails provided this method? validates :email, presence: true, uniqueness: true",
    answer: :rails,
    explanation: "`validates` is an ActiveModel/ActiveRecord method from Rails that adds validation rules to models.",
    sent_at: 1.day.ago,
    success_rate: 100
  }
]

success_rate_by_question = archived_puzzles.to_h { |p| [ p[:question], p[:success_rate] ] }

archived_puzzles.each do |p|
  Puzzle.find_or_create_by!(question: p[:question]) do |puzzle|
    puzzle.answer = p[:answer]
    puzzle.explanation = p[:explanation]
    puzzle.state = :archived
    puzzle.sent_at = p[:sent_at]
  end
end

# ====== Clone a few archived puzzles so the "hide cloned" filter has data ======
# Mix of pending and archived clones to exercise both states.
cloned_sources = [
  { question: "Ruby or Rails provided this method? before_action :authenticate_user!", state: :pending },
  { question: "Ruby or Rails provided this method? User.where(active: true).order(:name)", state: :pending },
  { question: "Ruby or Rails provided this method? 42.times { puts 'hello' }", state: :archived, sent_at: 12.hours.ago },
  { question: "Ruby or Rails provided this method? flash[:notice] = 'Saved!'", state: :archived, sent_at: 6.hours.ago }
]

cloned_sources.each do |source|
  parent = Puzzle.find_by(question: source[:question])
  next unless parent
  next if Puzzle.where(original_puzzle_id: parent.id).exists?

  Puzzle.create!(
    question: "#{parent.question} (clone)",
    answer: parent.answer,
    explanation: parent.explanation,
    link: parent.link,
    suggested_by: parent.suggested_by,
    state: source[:state],
    sent_at: source[:sent_at],
    original_puzzle: parent
  )
end

# ====== Create the Server ======
server = Server.find_or_create_by!(server_id: 1179555097060061245) do |s|
  s.name = "OmbuTest"
end

# ====== Create Users and associate with Server ======
users = [
  { user_id: 101, username: "user1", role: "member" },
  { user_id: 102, username: "user2", role: "member" },
  { user_id: 103, username: "user3", role: "member" },
  { user_id: 104, username: "user4", role: "member" },
  { user_id: 105, username: "user5", role: "member" },
  { user_id: 106, username: "user6", role: "member" },
  { user_id: 107, username: "user7", role: "member" },
  { user_id: 108, username: "user8", role: "member" },
  { user_id: 109, username: "user9", role: "member" },
  { user_id: 110, username: "user10", role: "member" }
]

users.each do |user_data|
  user = User.find_or_create_by!(user_id: user_data[:user_id]) do |u|
    u.username = user_data[:username]
    u.role = user_data[:role]
  end

  # Associate user with the server if not already linked
  user.servers << server unless user.servers.include?(server)
end

# ====== Seed answers for archived puzzles ======
# Real users only answer puzzles after they've been sent (archived state).
# For each archived puzzle, mark the first `success_rate / 10` users correct
# and the rest incorrect, so each puzzle hits its target rate exactly.
server_users = server.users.order(:id)

Puzzle.archived.each do |puzzle|
  base_question = puzzle.original_puzzle&.question || puzzle.question
  correct_count = success_rate_by_question.fetch(base_question, 50) / 10

  server_users.each_with_index do |user, idx|
    Answer.find_or_create_by!(
      user_id: user.id,
      puzzle_id: puzzle.id,
      server_id: server.id
    ) do |answer|
      answer.choice = [ "ruby", "rails" ].sample
      answer.is_correct = idx < correct_count
    end
  end
end
