class Student < ActiveRecord::Base
  before_save { self.email=email.downcase }
  has_many       :student_semesters, :dependent => :destroy
  has_many       :bookings,          :dependent => :destroy
  has_many       :marks,             :dependent => :destroy
  
  attr_accessor  :password
  before_destroy :ensure_not_referenced
  
  validates :sid, :uniqueness => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 100000000 }, :presence => true
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :cp, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :phone, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }, :allow_blank => true # phone number is optional
  # please don't add any password validation here, add at the user table
    

  def ensure_not_referenced
    errors[:base] << "Student has bookings" if !bookings.count.zero?
    errors[:base] << "Student has marks"    if !marks.count.zero?

    if errors[:base].length > 0
      return false
    else
      return true
    end
  end
  
  def to_csv
    csv_line = [sid, cp, first_name, last_name, email, "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A",]
    #in the system a student can have 10 labs, 3 reports, 2 talks, 1 poster and 1 assignment
    num_labs = 10
    num_reports = 3
    num_talks = 2
    num_posters = 1
    num_assignments = 1
    
    # Get a list of experiment the student booked
      sem_start   = Setting.getSetting('sem_start', 'date')
      sem_end     = Setting.getSetting('sem_end', 'date')
        
      @student = Student.find(self.id)
      bookings = @student.bookings.where(:date => (sem_start .. sem_end))
      experiment_set = Set.new
      bookings.each do |b|
        experiment_set.add(b.experiment)
      end
      
      @experiment = experiment_set.to_a
      @mark_table = Array.new(@experiment.length)
      
      # hash for mark type
      mark_type_hash = Hash.new
      mark_type_hash['experiment'] = 0
      mark_type_hash['report'] = 1
      mark_type_hash['poster'] = 2
      mark_type_hash['talk'] = 3
      mark_type_hash['assignment'] = 4

    for i in 0 .. (@experiment.length - 1) do
        marks = @experiment[i].marks.where(:student_id => @student.id)
        row = Array.new(5, nil)
        @mark_table[i] = row
        
        marks.each do |m|
          index = mark_type_hash[m.mark_type]
      row[index] = m.mark
      if index == 0 #labs
        if num_labs > 0
          csv_line[15-num_labs] = m.mark
          num_labs -= 1
        end
      elsif index == 1 #reports
        if num_reports > 0
          csv_line[18-num_reports] = m.mark
          num_reports -= 1 
        end
      elsif index == 2 #poster
        if num_posters > 0
          csv_line[18] = m.mark
          num_posters -= 1
        end
      elsif index == 3 #talks
        if num_talks > 0
          csv_line[21-num_talks] = m.mark
          num_talks -= 1
        end
      elsif index == 4 #assignment
        if num_assignments > 0
          csv_line[21] = m.mark
          num_assignments -= 1
        end
      end
        end
      end
    return csv_line
  end
end
