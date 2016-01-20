require_relative 'ModelBase.rb'

class Likes < ModelBase
  attr_accessor :id, :user_id, :question_id

  def initialize(options)
    @id, @user_id, @question_id = options.values_at('id', 'user_id', 'question_id')
  end

  def insert
    data = QuestionsDatabase.instance.execute(<<-SQL, @user_id, @question_id)
      INSERT INTO
        users(user_id, question_id)
      VALUES
        ?, ?
    SQL
    @id = SQLite3::Database.last_insert_row_id
  end

  def update
    data = QuestionsDatabase.instance.execute(<<-SQL, @user_id, @question_id)
      UPDATE
        users(user_id, question_id)
      SET
        ?, ?
    SQL
  end

  def self.likers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      users.id, fname, lname
    FROM
      likes
    JOIN
      users ON users.id = user_id
    WHERE
      question_id = #{question_id}
    SQL
    data.map { |datum| Users.new(datum) }
  end

  def self.num_likes_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      COUNT(question_id)
    FROM
      likes
    WHERE
      question_id = #{question_id}
    SQL
    data.first.values.first #Better way?
  end

  def self.liked_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      questions.id, title, body, author_id
    FROM
      likes
    JOIN
      questions ON questions.id = question_id
    WHERE
      user_id = #{user_id}
    SQL
    data.map { |datum| Questions.new(datum) }
  end

  def self.most_liked_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        questions.id, title, body, author_id
      FROM
        questions
      JOIN
        likes ON questions.id = question_id
      GROUP BY
        question_id
      ORDER BY
        COUNT(user_id) DESC
      LIMIT
        #{n}
    SQL
    data.map { |datum| Questions.new(datum) }
  end

end
