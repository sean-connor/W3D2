require_relative 'ModelBase.rb'

class Replies < ModelBase
  attr_accessor :id, :question_id, :respondent_id, :body, :parent_id

  def initialize(options)
    @id, @question_id, @respondent_id, @body, @parent_id = options.values_at('id', 'question_id', 'respondent_id', 'body', 'parent_id')
  end
  
  def insert
    data = QuestionsDatabase.instance.execute(<<-SQL, @question_id, @respondent_id, @body, @parent_id)
      INSERT INTO
        users(question_id, respondent_id, body, parent_id)
      VALUES
        ?, ?, ?, ?
    SQL
    @id = SQLite3::Database.last_insert_row_id
  end

  def update
    data = QuestionsDatabase.instance.execute(<<-SQL, @question_id, @respondent_id, @body, @parent_id)
      UPDATE
        users(question_id, respondent_id, body, parent_id)
      SET
        ?, ?, ?, ?
    SQL
  end

  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      replies
    WHERE
      respondent_id = #{user_id}
    SQL
    data.map { |datum| self.new(datum) }
  end

  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = #{question_id}
    SQL
    data.map { |datum| self.new(datum) }
  end

  def author
    Users.find_by_user_id(@respondent_id)
  end

  def questions
    Questions.find_by_question_id(@question_id)
  end

  def parent_reply
    Replies.find_by_id(@parent_id)
  end

  def child_replies
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      parent_id = ?
    SQL
    data.map { |datum| Replies.new(datum) }
  end

end
