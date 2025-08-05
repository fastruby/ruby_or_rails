
# db/seeds.rb

# Create Puzzle records
Puzzle.create!([
  { question: "Ruby or Rails provided this method? Array.new(5) { |i| i * 2 }", answer: :ruby, explanation: "`Array.new` is a core Ruby method that creates a new array with a specified size and optional block for initialization. This is part of Ruby’s core library." },
  { question: "Ruby or Rails provided this method? File.open('log.txt', 'w') { |file| file.write('Hello, World!') }", answer: :ruby, explanation: "`File.open` is a core Ruby method for opening files. It’s part of Ruby's standard library for file handling, not part of Rails." },
  { question: "Ruby or Rails provided this method? render json: @user", answer: :rails, explanation: "`render json:` is a Rails method used to render a JSON response from a controller action." },
  { question: "Ruby or Rails provided this method? link_to 'Home', root_path", answer: :rails, explanation: "`link_to` is a Rails helper method that generates HTML links. `root_path` is a Rails path helper." },
  { question: "Ruby or Rails provided this method? params[:id]", answer: :rails, explanation: "`params[:id]` is used in Rails to fetch query parameters or URL parameters in controller actions." }
])

# Create a server
Server.create!(server_id: 1179555097060061245, name: "OmbuTest")

# Seed data for 10 users with answers
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
  user = User.create(user_id: user_data[:user_id], username: user_data[:username], role: user_data[:role])

  # Randomly assign scores to answers (you can adjust as needed)
  3.times do
    Answer.create!(
      user_id: user.id,
      puzzle_id: Puzzle.all.sample.id,
      server_id: Server.first.id,
      choice: [ "ruby", "rails" ].sample,
      is_correct: [ true, false ].sample
    )
  end
end
