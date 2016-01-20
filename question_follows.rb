require_relative 'ModelBase.rb'

class QuestionFollows < ModelBase
  attr_accessor :id, :follower_id, :question_id

  def initialize(options)
    @id, @follower_id, @question_id = options.values_at('id', 'follower_id', 'question_id')
  end

  def insert
    data = QuestionsDatabase.instance.execute(<<-SQL, @follower_id, @question_id)
      INSERT INTO
        users(follower_id, question_id)
      VALUES
        ?, ?
    SQL
    @id = SQLite3::Database.last_insert_row_id
  end

  def update
    data = QuestionsDatabase.instance.execute(<<-SQL, @follower_id, @question_id)
      UPDATE
        users(follower_id, question_id)
      SET
        ?, ?
    SQL
  end

  def self.followers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        users.id, users.fname, users.lname
      FROM
        users
      JOIN
        question_follows ON users.id = follower_id
      WHERE
        question_id = #{question_id}
    SQL
    data.map { |data| Users.new(data) }
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        questions.id, title, body, author_id
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_id
      WHERE
        follower_id = #{user_id}
    SQL
    data.map { |data| Questions.new(data) }
  end

  def self.most_followed_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        questions.id, title, body, author_id
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_id
      GROUP BY
        question_id
      ORDER BY
        COUNT(follower_id) DESC
      LIMIT
        #{n}
    SQL
    data.map { |datum| Questions.new(datum) }
  end
end
