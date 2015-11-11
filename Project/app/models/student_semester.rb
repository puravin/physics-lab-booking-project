class StudentSemester < ActiveRecord::Base
  belongs_to :student
  
  validates_uniqueness_of :student_id, :scope => [:year, :semester]
end
