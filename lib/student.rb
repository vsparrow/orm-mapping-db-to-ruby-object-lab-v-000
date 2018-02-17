class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    # puts "************#{row}" id,name,grade
    s = Student.new()
    # puts "*******#{row[0]} #{row[1]} #{row[2]}"
    s.id =  row[0].to_i
    s.name= row[1]
    s.grade=row[2].to_i
    s
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end #map
  end #all

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    # puts "********#{name}"
    sql = "SELECT * FROM students WHERE name = (?)"
    found = DB[:conn].execute(sql,name).map  do |row|
    # row =row.map
    # puts "********#{row}" #<Enumerator:0x007f8592a16688>
      self.new_from_db(row)
    end #map
    # puts "****#{found}"  # [[1, "Pat", "12"]]
    #return is the return from new_from_db
    # puts "****#{found.name}"
    # puts "****#{}"
    # puts "****#{}"
    found[0]
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = "10"
      LIMIT ?
    SQL
    DB[:conn].execute(sql,x)
  end

  def self.first_student_in_grade_10
    Student.new_from_db(Student.first_X_students_in_grade_10(1)[0])  #returns array of arrays so must send array[0]
    # row = Student.first_X_students_in_grade_10(1)
    # puts "******#{row}"
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL
    DB[:conn].execute(sql,x)
  end #all_students_in_grade_X

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = "9"
    SQL
    rows = DB[:conn].execute(sql)
    # puts "********#{rows}"
  end #count_all_students_in_grade_9

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade != "12"
    SQL
    row=DB[:conn].execute(sql)
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
