describe Question do
  before do
    DB[:conn].execute("DROP TABLE IF EXISTS questions")
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS questions (
        id INTEGER PRIMARY KEY,
        title TEXT,
        content TEXT,
        views INTEGER
      )
    SQL
    DB[:conn].execute(sql)
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
    it 'has a title, content, and views' do
      question = Question.new(title: "How do I join in SQL?", content: "Please Send Help.", views: 42)
      expect(question).to have_attributes(title: "How do I join in SQL?", content: "Please Send Help.", views: 42)
    end

    it 'has an id that defaults to `nil` on initialization' do
      question = Question.new(title: "How do I join in SQL?", content: "Please Send Help.", views: 42)
      expect(question.id).to eq(nil)
    end
  end

  describe "#save" do
    it 'returns an instance of the question class' do
      question = Question.new(title: "How do I join in SQL?", content: "Please Send Help.", views: 42)
      question.save

      expect(question).to have_attributes(
        class: Question,
        id: 1,
        title: "How do I join in SQL?",
        content: "Please Send Help.",
        views: 42
      )
    end

    it 'saves an instance of the question class to the database and then sets the given questions `id` attribute' do
      question = Question.new(title: "How do I join in SQL?", content: "Please Send Help.", views: 42)
      question.save

      expect(DB[:conn].execute("SELECT * FROM questions WHERE id = 1")).to eq([[1, "How do I join in SQL?", "Please Send Help.", 42]])
    end
  end

  describe ".create" do
    it 'create a new question object and uses the #save method to save that question to the database'do
      Question.create(title: "How do I join in SQL?", content: "Please Send Help.", views: 42)
      expect(DB[:conn].execute("SELECT * FROM questions")).to eq([[1, "How do I join in SQL?", "Please Send Help.", 42]])
    end

    it 'returns a new question object' do
      question = Question.create(title: "How do I join in SQL?", content: "Please Send Help.", views: 42)

      expect(question).to have_attributes(
        class: Question,
        id: 1,
        title: "How do I join in SQL?",
        content: "Please Send Help.",
        views: 42
      )
    end
  end

  describe '.new_from_db' do
    it 'creates an instance with corresponding attribute values' do
      row = [1, "How do I join in SQL?", "Please Send Help.", 42]
      question = Question.new_from_db(row)

      expect(question).to have_attributes(
        class: Question,
        id: 1,
        title: "How do I join in SQL?",
        content: "Please Send Help.",
        views: 42
      )
    end
  end

  describe '.all' do
    it 'returns an array of question instances for all records in the questions table' do
      Question.create(title: "How do I join in SQL?", content: "Please Send Help.", views: 42)
      Question.create(title: "Need help capitalizing in Ruby!", content: "Please Send More Help.", views: 15)
      expect(Question.all).to match_array([
        have_attributes(
          class: Question,
          id: 1,
          title: "How do I join in SQL?",
          content: "Please Send Help.",
          views: 42
        ),
        have_attributes(
          class: Question,
          id: 2,
          title: "Need help capitalizing in Ruby!",
          content: "Please Send More Help.",
          views: 15
        )
      ])
    end
  end

  describe '.find_by_title' do
    it 'returns an instance of question that matches the name from the DB' do
      Question.create(title: "How do I join in SQL?", content: "Please Send Help.", views: 42)
      Question.create(title: "Need help capitalizing in Ruby!", content: "Please Send More Help.", views: 15)

      question_from_db = Question.find_by_title("How do I join in SQL?")

      expect(question_from_db).to have_attributes(
        class: Question,
        id: 1,
        title: "How do I join in SQL?",
        content: "Please Send Help.",
        views: 42
      )
    end
  end

  describe '.find' do
    it 'returns a new question object by id' do
      Question.create(title: "How do I join in SQL?", content: "Please Send Help.", views: 42)
      Question.create(title: "Need help capitalizing in Ruby!", content: "Please Send More Help.", views: 15)

      question_from_db = Question.find(1)

      expect(question_from_db).to have_attributes(
        class: Question,
        id: 1,
        title: "How do I join in SQL?",
        content: "Please Send Help.",
        views: 42
      )
    end
  end

  describe '#answers' do
    it 'returns all the answers for a given question' do
      question = Question.create(title: "How do I join in SQL?", content: "Please Send Help.", views: 42)
      Answer.create(content: "Just use an Inner Joins!", votes: 10, question_id: 1)
      Answer.create(content: "Have you tried SELECT?", votes: 0, question_id: 1)

      answers_from_db = question.answers
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
