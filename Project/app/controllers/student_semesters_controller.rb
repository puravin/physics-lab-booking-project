class StudentSemestersController < ApplicationController
  # POST /student_semesters
  # POST /student_semesters.xml
  def create
    @student_semester = StudentSemester.new(params[:student_semester])

    if @student_semester.save
      redirect_to :controller => 'students', :action => 'show', :id => params[:student_semester][:student_id], :notice => 'Student semester was successfully added.'
    else
      redirect_to :controller => 'students', :action => 'show', :id => params[:student_semester][:student_id], :error => 'Unable to add the semester.'
    end
  end

  # DELETE /student_semesters/1
  # DELETE /student_semesters/1.xml
  def destroy
    @student_semester = StudentSemester.find(params[:id])
    student_id = @student_semester.student_id
    @student_semester.destroy

    redirect_to :controller => 'students', :action => 'show', :id => student_id, :notice => 'Student semester was successfully removed.'
  end
end
