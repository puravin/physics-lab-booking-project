class MarksController < ApplicationController
  # GET /marks
  # GET /marks.xml
  def index
    # Determine the current year and semester
    time = Time.new
    this_year = time.year.to_s
    this_semester = time.mon <= 6 ? '1' : '2'
    
    # Get the student list
    @students = Student.joins(:student_semesters).find(:all, :conditions => { 'student_semesters.semester' => this_semester, 'student_semesters.year' => this_year}, :group => :student_id, :order => "last_name")

    @importRight = Permission.hasAccess('CsvImportController', session[:role])
    @exportRight = Permission.hasAccess('CsvExportController', session[:role])
    
    # Render page
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @students }
    end
  end

  def edit
    # Get a list of experiment the student booked
    sem_start   = Setting.getSetting('sem_start', 'date')
    sem_end     = Setting.getSetting('sem_end', 'date')
      
    @student = Student.find(params[:student_id])
    bookings = @student.bookings.where(:date => (sem_start .. sem_end))
    marks = @student.marks.where(:updated_at => (sem_start .. sem_end))
    experiment_set = Set.new
    bookings.each do |b|
      experiment_set.add(b.experiment)
    end
    marks.each do |m|
      experiment_set.add(m.experiment)
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
    
    # determine the access permission
    is_admin = session[:role] == "admin"
    user = User.find_by_username(session[:username])
    
    # Generate the table for marks
    for i in 0 .. (@experiment.length - 1) do
      marks = @experiment[i].marks.where(:student_id => @student.id)
      row = Array.new(5, [true, 0, '']) # [allow to change mark?, old mark, additional info]
      @mark_table[i] = row
      
      marks.each do |m|
        index = mark_type_hash[m.mark_type]
        if is_admin
          marker = User.find(m.user_id)
          tutor = Tutor.find_by_username(marker.username)
          name = marker.username
          if tutor.present?
            name = tutor.first_name << ' ' << tutor.last_name
          end
          row[index] = [true, m.mark, 'Recorded by ' << name]
        elsif m.user == user
          row[index] = [true, m.mark, '']
        else
          row[index] = [false, 0, 'Mark recorded on ' << m.created_at.to_s]
        end
      end
    end
  end

  def save_mark
    # Get all the marks entered
    marks = []
    mark_type = ['experiment', 'report', 'poster', 'talk', 'assignment']
    params.each do |key, value|
      if key[0..4] == "mark_" && value.length > 0
        key_split = key.split('_')
        exp_num = key_split[1].to_i
        mark_type_id = key_split[2].to_i
        marks << [exp_num, mark_type[mark_type_id], value.to_d]
      end
    end
    
    student = Student.find(params[:student_id])
    user = User.find_by_username(session[:username])
    
    success = true
    marks.each do |mark|
      # Try to retrieve the previous mark
      experiment = Experiment.find_by_exp_num(mark[0])
      old_mark = Mark.where(:experiment_id => experiment.id, :student_id => student.id, :mark_type => mark[1])
      
      # Save the mark
      if old_mark.blank?
        if mark[2] > 0
          old_mark = Mark.new(:experiment => experiment, :student => student, :user => user, :mark_type => mark[1], :mark => mark[2])
          success &= old_mark.save
        end
      else
        if mark[2] == 0
          old_mark.each do |m|
            m.destroy
          end
        else
          old_mark = old_mark.first
          success &= old_mark.update_attributes(:mark => mark[2])
        end
      end
    end
    
    if success
      redirect_to :action => 'edit', :notice => 'All marks has been successfully saved.', :student_id => student.id
    else
      redirect_to :action => 'edit', :error => 'Fail to save some of the marks.', :student_id => student.id
    end
  end
end

