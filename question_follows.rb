class QuestionFollows
  attr_accessor :id, :follower_id, :question_id

  def initialize(options)
    @id, @follower_id, @question_id = options.values_at('id', 'follower_id', 'question_id')
  end

  def self.find_by_id(find_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      question_follows
    WHERE
      id = #{find_id}
    SQL
    self.new(data[0])
  end
end
