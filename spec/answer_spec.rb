describe Answer do
  before do
    DB[:conn].execute("DROP TABLE IF EXISTS questions")
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS answers (
        id INTEGER PRIMARY KEY,
        content TEXT,
        votes INTEGER,
        question_id INTEGER
      )
    SQL
    DB[:conn].execute(sql)
  end

  describe "attributes" do
    it 'has a content, votes, and question_id' do
      answer = Answer.new(content: "Just use an Inner Joins!", votes: 10, question_id: 1)
      expect(answer).to have_attributes(content: "Just use an Inner Joins!", votes: 10, question_id: 1)
    end

    it 'has an id that defaults to `nil` on initialization' do
      answer = Answer.new(content: "Just use an Inner Joins!", votes: 10, question_id: 1)
      expect(answer.id).to eq(nil)
    end
  end

  describe "#save" do
    it 'returns an instance of the question class' do
      answer = Answer.new(content: "Just use an Inner Joins!", votes: 10, question_id: 1)
      answer.save

      expect(answer).to have_attributes(
        class: Answer,
        id: 1,
        content: "Just use an Inner Joins!",
        votes: 10,
        question_id: 1
      )
    end

    it 'saves an instance of the answer class to the database and then sets the given answers `id` attribute' do
      answer = Answer.new(content: "Just use an Inner Joins!", votes: 10, question_id: 1)
      answer.save

      expect(DB[:conn].execute("SELECT * FROM answers WHERE id = 1")).to eq([[1, "Just use an Inner Joins!", 10, 1]])
    end
  end

  describe ".create" do
    it 'create a new question object and uses the #save method to save that question to the database'do
      Answer.create(content: "Just use an Inner Joins!", votes: 10, question_id: 1)
      expect(DB[:conn].execute("SELECT * FROM answers")).to eq([[1, "Just use an Inner Joins!", 10, 1]])
    end

    it 'returns a new answer object' do
      answer = Answer.create(content: "Just use an Inner Joins!", votes: 10, question_id: 1)

      expect(answer).to have_attributes(
        class: Answer,
        id: 1,
        content: "Just use an Inner Joins!",
        votes: 10,
        question_id: 1
      )
    end
  end

  describe '.new_from_db' do
    it 'creates an instance with corresponding attribute values' do
      row = [1, "Just use an Inner Joins!", 10, 1]
      answer = Answer.new_from_db(row)

      expect(answer).to have_attributes(
        class: Answer,
        id: 1,
        content: "Just use an Inner Joins!",
        votes: 10,
        question_id: 1
      )
    end
  end

  describe '.find_all_by_question_id' do
    it 'returns an instance of question that matches the name from the DB' do
      Answer.create(content: "Just use an Inner Joins!", votes: 10, question_id: 1)
      Answer.create(content: "Have you tried SELECT?", votes: 0, question_id: 1)

      answers_from_db = Answer.find_all_by_question_id(1)

      expect(answers_from_db).to match_array([
        have_attributes(
          class: Answer,
          id: 1,
          content: "Just use an Inner Joins!",
          votes: 10,
          question_id: 1
        ),
        have_attributes(
          class: Answer,
          id: 2,
          content: "Have you tried SELECT?",
          votes: 0,
          question_id: 1
        )
      ])
    end
  end
end
