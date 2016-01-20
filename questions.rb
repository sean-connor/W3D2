require_relative 'ModelBase.rb'

class Questions < ModelBase
  attr_accessor :id, :title, :body, :author_id

  def initialize(options)
    @id, @title, @body, @author_id = options.values_at('id', 'title', 'body', 'author_id')
  end

  def insert
    data = QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @author_id)
      INSERT INTO
        users(title, body, author_id)
      VALUES
        ?, ?, ?
    SQL
    @id = SQLite3::Database.last_insert_row_id
  end

  def update
    data = QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @author_id)
      UPDATE
        users(title, body, author_id)
      SET
        ?, ?, ?
    SQL
  end

  def self.find_by_author(first, last)
    data = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      users
    JOIN
      questions ON users.id = author_id
    WHERE
      users.fname = '#{first}' AND users.lname = '#{last}'
    SQL
    data.map { |datum| self.new(datum) }
  end

  def self.find_by_author_id(author_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      questions
    WHERE
      author_id = #{author_id}
    SQL
    data.map { |datum| self.new(datum) }
  end

  def author
    Users.find_by_id(@author_id)
  end

  def replies
    Replies.find_by_question_id(@question_id)
  end

  def followers
    QuestionFollows.followers_for_question_id(@id)
  end

  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end

  def likers
    Likes.likers_for_question_id(@id)
  end

  def num_likes
    Likes.num_likes_for_question_id(@id)
  end

  def most_liked(n)
    Likes.most_liked_questions(n)
  end
end
