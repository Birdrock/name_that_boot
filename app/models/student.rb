class Student
  attr_accessor :id, :name, :gravatar

  def initialize(data = {})
    @id = data[:id]
    @name = data[:name]
    @gravatar = data[:gravatar]
    @sample_names = data[:sample_names]
  end

  def self.find_students_by_cohort_id(cohort_id)
    students = DBC::Cohort.find(cohort_id).students.select{|student| student.roles.include?("student") && student.roles.size == 1}
    original_students = students.clone.map! { |current_student| current_student.name }
    students.map!{|student| Student.new(id: student.id, name: student.name,
                                        gravatar: Student.gravatar_url_from_email(student.email),
                                        sample_names: Student.create_sample_names(student, original_students))}
    students.shuffle
  end

  def self.gravatar_url_from_email(email)
    "https://secure.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}.png?d=mm&r=PG&s=250"
  end

  def self.create_sample_names(student, students)
    copy = students.clone
    copy.delete(student.name)
    copy = copy.sample(3)
    copy << student.name
    copy.shuffle
  end
end
