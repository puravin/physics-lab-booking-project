class StudentsController < ApplicationController
  # GET /students
  # GET /students.xml
  # List the students base on the filter criteria
  def index
    # Determine the current year and semester
    time = Time.new
    this_year = time.year.to_s
    this_semester = time.mon <= 6 ? '1' : '2'

    time = Time.new
    @semesters = { ' Both semesters' => 'all', 'Semester 1' => '1', 'Semester 2' => '2'}
    @years = { ' All years' => 'all' }
    for n in 2007...(time.year + 2)
      @years["#{n}"] = "#{n}"
    end
    
    # Get the filter condition from GET parameter
    # If no parameters are given, current year and semester will be selected
    @semester = params[:semester] ? params[:semester] : this_semester
    @year = params[:year] ? params[:year] : this_year
    conditions = {}
    
    Rails.cache.write("year",@year)
    Rails.cache.write("semester",@semester)

    if @semester != 'all'
      conditions['student_semesters.semester'] = @semester
    end
    if @year != 'all'
      conditions['student_semesters.year'] = @year
    end

    # Get the student list
    if !conditions.empty?
      @students = Student.joins(:student_semesters).find(:all, :conditions => conditions, :group => :student_id, :order => "last_name")
    else
      @students = Student.all(:order => "last_name")
    end

    # Render page
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @students }
    end
  end

  # GET /students/1
  # GET /students/1.xml
  def show
    # Get student details
    @student = Student.find(params[:id])
    @requirement = CreditPoint.find_by_cp(@student.cp)

    # Prepare adding semester dropdown box
    @semesters = { 'Semester 1' => '1', 'Semester 2' => '2'}
    @years = {}
    time = Time.new
    n = 2007
    while n <= time.year + 1
      @years["#{n}"] = "#{n}"
      n = n + 1
    end
    
    @year = time.year.to_s
    @semester = time.mon <= 6 ? '1' : '2'

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end

  # GET /students/new
  # GET /students/new.xml
  def new
    @student = Student.new
    generate_cp_map

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student }
    end
  end

  # GET /students/1/edit
  def edit
    @student = Student.find(params[:id])
    generate_cp_map
  end

  # POST /students
  # POST /students.xml
  def create
    @student = Student.new(params[:student])
    @user = User.new(:username => params[:student][:sid], :password => params[:student][:password], :role => "student", :details_id => params[:student][:sid]);

    # Trying to save the data
    save_success = true
    Student.transaction do
      # Add the student to current semester
      if params[:current_semester][:selected] == "1"
        time = Time.new
        this_year = time.year.to_s
        this_semester = time.mon <= 6 ? 1 : 2
        @student_semester = StudentSemester.new(:student => @student, :semester => this_semester, :year => this_year)
        if not @student_semester.save
          save_success = false
          raise ActiveRecord::Rollback
        end
      end
      if (not @student.save) || (not @user.save)
        save_success = false
        raise ActiveRecord::Rollback
      end
    end
    
    respond_to do |format|
      if save_success
        # Send an email to the user regarding the registration
        SystemMailer.registrationEmail(@user.username, params[:student][:password], @student.email, root_url).deliver
        
        format.html { redirect_to(@student, :notice => 'Student was successfully created.') }
        format.xml  { render :xml => @student, :status => :created, :location => @student }
      else
        # Fail to create student
        # Migrate user creation error to student table
        @user.errors.each {|attr, msg|
          @student.errors.add(attr, msg)
        }
        generate_cp_map
        format.html { render :action => "new" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /students/1
  # PUT /students/1.xml
  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html { redirect_to(@student, :notice => 'Student was successfully updated.') }
        format.xml  { head :ok }
      else
        generate_cp_map
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.xml
  def destroy
    @student = Student.find(params[:id])
    @user = User.find_by_username(@student.sid)
    @student.destroy
    @user.destroy
    
    respond_to do |format|
      format.html { redirect_to(students_url) }
      format.xml  { head :ok }
    end
  end
  
  def generate_cp_map()
    @cp = {}
    CreditPoint.all.each do |cp|
      @cp[cp.cp.to_s] = cp.cp
    end
  end
end
