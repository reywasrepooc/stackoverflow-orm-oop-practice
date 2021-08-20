class Answer
  attr_reader :content, :votes, :question_id
  attr_accessor :id

  def initialize(content:, votes:, question_id:, id: nil)
    @content = content
    @votes = votes
    @id = id
    @question_id = question_id
  end

  def save
    sql = <<-SQL
      INSERT INTO answers (content, votes, question_id)
      VALUES (?, ?, ?)
    SQL
    DB[:conn].execute(sql, content, votes, question_id)
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM answers")[0][0]
    self
  end

  def self.create(content:, votes:, question_id:)
    answer = Answer.new(content: content, votes: votes, question_id: question_id)
    answer.save
  end

  def self.new_from_db(row)
    new(id: row[0], content: row[1], votes: row[2], question_id: row[3])
  end

  def self.find_all_by_question_id(question_id)
    sql = <<-SQL
      SELECT *
      FROM answers
      WHERE question_id = ?
    SQL
    DB[:conn].execute(sql, question_id).map do |row|
      new_from_db(row)
    end
  end
end
