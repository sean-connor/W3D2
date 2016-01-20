require_relative 'questions.rb'
require_relative 'ModelBase.rb'

class Users < ModelBase
  attr_accessor :id, :fname, :lname

  def initialize(options)
    @id, @fname, @lname = options.values_at('id', 'fname', 'lname')
  end

  def insert
    data = QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
      INSERT INTO
        users(fname, lname)
      VALUES
        ?, ?
    SQL
    @id = SQLite3::Database.last_insert_row_id
  end

  def update
    data = QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
      UPDATE
        users(fname, lname)
      SET
        ?, ?
    SQL
  end

  def self.find_by_name(first, last)
    data = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      users
    WHERE
      users.fname = '#{first}' AND users.lname = '#{last}'
    SQL
    self.new(data[0])
  end

  def authored_questions
    Questions.find_by_author_id(@id)
  end

  def authored_replies
    Replies.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollows.followed_questions_for_user_id(@id)
  end

  def liked_questions
    Likes.liked_questions_for_user_id(@id)
  end

  def average_karma
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        COUNT(likes.id) / CAST(COUNT(DISTINCT questions.id) AS FLOAT)
      FROM
        questions
      LEFT OUTER JOIN
        likes ON questions.id = likes.question_id
      WHERE
        author_id = #{@id}
    SQL
  end
end
