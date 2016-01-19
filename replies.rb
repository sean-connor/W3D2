class Replies
  attr_accessor :id, :question_id, :respondent_id, :body, :parent_id

  def initialize(options)
    @id, @question_id, @respondent_id, @body, @parent_id = options.values_at('id', 'question_id', 'respondent_id', 'body', 'parent_id')
  end

  def self.find_by_id(find_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      replies
    WHERE
      id = #{find_id}
    SQL
    self.new(data[0])
  end

  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      replies
    WHERE
      user_id = #{user_id}
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
end
