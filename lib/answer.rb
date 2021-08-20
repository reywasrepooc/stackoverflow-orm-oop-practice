class Answer
  attr_reader :content, :votes, :question_id
  attr_accessor :id

  def intialize(content:, votes:, question_id:, id: nil)
    @content = content
    @votes = votes
    @id = id
    @question_id = question_id
  end

end
