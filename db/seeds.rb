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

  # Seed random answers for this user if they have none
  if user.answers.where(server_id: server.id).empty?
    3.times do
      puzzle = Puzzle.all.sample
      Answer.find_or_create_by!(
        user_id: user.id,
        puzzle_id: puzzle.id,
        server_id: server.id
      ) do |answer|
        answer.choice = [ "ruby", "rails" ].sample
        answer.is_correct = [ true, false ].sample
      end
    end
  end
end
