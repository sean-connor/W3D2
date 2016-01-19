class Users
  attr_accessor :id, :fname, :lname

  def initialize(options)
    @id, @fname, @lname = options.values_at('id', 'fname', 'lname')
  end

  def self.find_by_id(find_id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      users
    WHERE
      id = #{find_id}
    SQL
    self.new(data[0])
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
    
  end
end
