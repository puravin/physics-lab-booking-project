class DownloadReportsController < ApplicationController
  def index
    # Determine the current year and semester
    time = Time.new
    this_year = time.year.to_s
    this_semester = time.mon <= 6 ? '1' : '2'
    
    # Get the student list
    student_list = Student.joins(:student_semesters).find(:all, :conditions => { 'student_semesters.semester' => this_semester, 'student_semesters.year' => this_year}, :group => :student_id, :order => "last_name")

    @students = []
    student_list.each do |s|
      user = User.find_by_username(s.sid)
      report = user.reports
      report_num = report.length
      @students << {"id" => s.id, "sid" => s.sid, "first_name" => s.first_name, "last_name" => s.last_name, "report_num" => report_num}
    end
    
    # Render page
    respond_to do |format|
      format.html # index.html.erb
      format
    end
  end

  def detail
    @student = Student.find(params[:student_id])
    user = User.find_by_username(@student.sid)
    @reports = user.reports
  end
end
