class CsvExportController < ApplicationController
  def index
		# Render page
		respond_to do |format|
		format.html # index.html.erb
		end
	end
  
	def mark
		# Render dropbox for year and semester
		time = Time.new
		this_year = time.year.to_s
		this_semester = time.mon <= 6 ? '1' : '2'

		time = Time.new
		@semesters = { 'Semester 1' => '1', 'Semester 2' => '2'}
		@years = {}
		for n in 2007...(time.year + 1)
		  @years["#{n}"] = "#{n}"
		end
		
		@semester = params[:semester] ? params[:semester] : this_semester
		@year = params[:year] ? params[:year] : this_year
		
    computeStudentMarks(@year.to_i, @semester.to_i)
    
		# Render page
		respond_to do |format|
		format.html # index.html.erb
		end
	end
	
	def export_mark
    if params[:year].blank? || params[:semester].blank?
      redirect_to :action => :mark, :error => "No year or semester given."
      return
    end
    
    # Get the marks
    computeStudentMarks(params[:year].to_i, params[:semester].to_i)
		
		# Heading
		csv_data = 'SID, First Name, Last Name, Email, Credit Points'
    mark_type = ['Experiment', 'Report', 'Poster', 'Talk', 'Assignment']
    for i in 0..4
      for j in 1..(@marks_max[i])
        csv_data << ', ' << mark_type[i] << ' ' << j.to_s << ', Mark'
      end
    end
    csv_data << "\n"
    
    # Generate content
    col_count = @marks_max.inject(:+)
    @result.each do |row|
      line = ''
      for i in 0..4
        line << row[i].to_s << ', '
      end
      for i in 5..9
        if row[i].present?
          row[i].each do |m|
            line << m[0].to_s << ', ' << m[1].to_s << ', '
          end
        end
        
        min = row[i].nil? ? 1 : row[i].length + 1
        for j in (min) .. (@marks_max[i - 5])
          line << ', , '
        end
      end
      csv_data << line[0..-3] << "\n"
    end
		
		#popup download dialogue for user
    filename = "student_mark_s#{params[:semester]}_#{params[:year]}"
		send_data csv_data, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=#{filename}.csv"
	end
  
  def computeStudentMarks(year, semester)
    # Get all student enrolled in the given semester
    conditions = {}
    conditions['student_semesters.semester'] = semester
    conditions['student_semesters.year'] = year
    students = Student.joins(:student_semesters).find(:all, :conditions => conditions, :group => :student_id, :order => "last_name")
    
    # Hash all the students
    @result = Hash.new(nil)
    students.each do |student|
      # sid, first_name, last_name, email, cp
      row = Array.new(10)
      row[0] = student.sid
      row[1] = student.first_name
      row[2] = student.last_name
      row[3] = student.email
      row[4] = student.cp
      @result[student.id] = row
    end
    
    # hash for mark type
    mark_type_hash = Hash.new
    mark_type_hash['experiment'] = 0
    mark_type_hash['report'] = 1
    mark_type_hash['poster'] = 2
    mark_type_hash['talk'] = 3
    mark_type_hash['assignment'] = 4
    
    # Get all marks and hash them
    sem_start = DateTime.new(year, (semester - 1) * 6 + 1, 1)
    sem_end = DateTime.new(year, semester * 6, 30)
    marks = Mark.joins(:experiment).where(:conditions => {'marks.updated_at' => (sem_start .. sem_end)})
    marks.each do |m|
      index = mark_type_hash[m.mark_type]
      row = @result[m.student_id]
      if not row.nil?
        if row[index + 5].nil?
          row[index + 5] = Array.new
        end
        row[index + 5] << [m.experiment.exp_num, m.mark]
      end
    end
    
    # sort the data
    @result = @result.values.sort{|x, y| x[2] <=> y[2]}
    
    # compute the length for each mark type
    @marks_max = Array.new(5, 1)
    @result.each do |row|
      for i in 0..5
        if not row[i + 5].blank?
          @marks_max[i] = [@marks_max[i], row[i + 5].length].max
        end
      end
    end
  end
  
  def booking
		# Render dropbox for year and semester
		time = Time.new
		this_year = time.year.to_s
		this_semester = time.mon <= 6 ? '1' : '2'

		time = Time.new
		@semesters = { 'Semester 1' => '1', 'Semester 2' => '2'}
		@years = {}
		for n in 2007...(time.year + 1)
		  @years["#{n}"] = "#{n}"
		end
		
		@semester = params[:semester] ? params[:semester] : this_semester
		@year = params[:year] ? params[:year] : this_year
		
    computeStudentBookings(@year.to_i, @semester.to_i)
    
		# Render page
		respond_to do |format|
		format.html # index.html.erb
		end
	end
	
	def export_booking
    if params[:year].blank? || params[:semester].blank?
      redirect_to :action => :mark, :error => "No year or semester given."
      return
    end
    
    # Get the bookings
    computeStudentBookings(params[:year].to_i, params[:semester].to_i)
		
		# Heading
		csv_data = 'SID, First name, Last name, Credit points, Experiment requirement, Booked sessions, Exp num, Exp name, Booked date '
    csv_data << "\n"
    
    # Generate content
    @result.each do |row|
      line = ''
      if row[5] == 0
        for i in 0..5
          line << row[i].to_s << ', '
        end
        line << ', ,' << "\n"
      else
        row[6].each do |b|
          for i in 0..5
            line << row[i].to_s << ', '
          end
          line << b[0].to_s << ', ' << b[1].to_s << ', ' << b[2].to_s << "\n"
        end
      end
      csv_data << line
    end
		
		#popup download dialogue for user
    filename = "student_booking_s#{params[:semester]}_#{params[:year]}"
		send_data csv_data, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=#{filename}.csv"
	end
  
  def computeStudentBookings(year, semester)
    # Get all student enrolled in the given semester
    conditions = {}
    conditions['student_semesters.semester'] = semester
    conditions['student_semesters.year'] = year
    students = Student.joins(:student_semesters).find(:all, :conditions => conditions, :group => :student_id, :order => "last_name")
    
    # Get the experiment requirements
    cp_exp_hash = Hash.new('N/A')
    CreditPoint.all.each do |cp|
      cp_exp_hash[cp.cp] = cp.experiment
    end
    
    # Get bookings for each student
    sem_start = DateTime.new(year, (semester - 1) * 6 + 1, 1)
    sem_end = DateTime.new(year, semester * 6, 30)
    @result = Array.new
    students.each do |s|
      row = Array.new(7)
      row[0] = s.sid
      row[1] = s.first_name
      row[2] = s.last_name
      row[3] = s.cp
      row[4] = cp_exp_hash[s.cp]
      
      bookings = s.bookings.joins(:experiment).find(:all, :conditions => {'bookings.updated_at' => (sem_start .. sem_end)}, :order => "date")
      row[5] = bookings.length
      booking_row = Array.new
      row[6] = booking_row
      bookings.each do |b|
        booking_row << [b.experiment.exp_num, b.experiment.name, b.date]
      end
      
      @result << row
    end
  end
end
