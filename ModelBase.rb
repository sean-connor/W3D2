class ModelBase

  def initialize
    @id = nil
  end

  def self.find_by_id(find_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      #{self.class}
    WHERE
      id = #{find_id}
    SQL
    self.new(data[0])
  end

  def save
    @id ? update : insert
  end

  def insert
  end

  def update
  end
end
