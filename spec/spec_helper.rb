require_relative '../config/environment'
DB[:conn] = SQLite3::Database.new ":memory:"

RSpec.configure do |config|
  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # you can do global before/after here like this:
  config.before do
    DB[:conn].execute("DROP TABLE IF EXISTS questions")
    DB[:conn].execute("DROP TABLE IF EXISTS answers")
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS questions (id INTEGER PRIMARY KEY, title TEXT, content TEXT, views INTEGER)")
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS answers (id INTEGER PRIMARY KEY, content TEXT, votes INTEGER, question_id INTEGER)")
  end

  config.after do
    DB[:conn].execute("DROP TABLE IF EXISTS questions")
    DB[:conn].execute("DROP TABLE IF EXISTS answers")
  end
end
