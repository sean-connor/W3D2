class Questions
  attr_accessor :id, :title, :body, :author_id

  def initialize(options)
    @id, @title, @body, @author_id = options.values_at('id', 'title', 'body', 'author_id')
  end

  def self.find_by_id(find_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      questions
    WHERE
      id = #{find_id}
    SQL
    self.new(data[0])
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
end
