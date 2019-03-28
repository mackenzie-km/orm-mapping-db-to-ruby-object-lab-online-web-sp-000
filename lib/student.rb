require "pry"

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    created = Student.new
    created.id = row[0]
    created.name = row[1]
    created.grade = row[2]
    created
  end

  def self.all
     sql = <<-SQL
      SELECT id, name, grade
      FROM students
      SQL

    found = DB[:conn].execute(sql, name)
    binding.pry
    found.map do |entry|
      self.new_from_db
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT id, name, grade
      FROM students
      WHERE name = ?
      SQL

    found = DB[:conn].execute(sql, name)

    new = self.new_from_db(found[0])
    new
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
