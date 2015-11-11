class UploadReportsController < ApplicationController
  def index
    @user = User.find_by_username(session[:username])
    @report = Report.new
    @report.user = @user
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @upload_reports }
    end
  end

  def upload
    report = Report.create(params[:report])
    if report.report_file_size > 0
      redirect_to(:action => 'index', :notice => 'Report has been successfully uploaded.')
    else
      report.destroy
      redirect_to(:action => 'index', :error => 'Unable to upload the report, please try again later.')
    end
  end
end
