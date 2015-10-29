class UsersController < ApplicationController
  def change_details
    if session[:role] == 'admin'
      render :template => 'users/change_admin_details.html.erb'
    elsif session[:role] == 'tutor'
      @tutor = Tutor.find_by_username(session[:username])
      render :template => 'users/change_tutor_details.html.erb'
    elsif session[:role] == 'student'
      @student = Student.find_by_sid(session[:username])
      render :template => 'users/change_student_details.html.erb'
    else
      render :status => :forbidden, :text => "You have no permission to access this page."
    end
  end
  
  def update_details
    # Save details
    begin
      if session[:role].nil?
        raise
      elsif session[:role] == 'tutor'
        @tutor = Tutor.find_by_username(session[:username])
        if @tutor.nil?
          raise 'Unable to find user details.'
        elsif not @tutor.update_attributes(:first_name => params[:first_name])
          raise 'Unable to save your first name.'
        elsif not @tutor.update_attributes(:last_name => params[:last_name])
          raise 'Unable to save your last name.'
        elsif not params[:phone].blank?
          if not @tutor.update_attributes(:phone => params[:phone])
            raise 'Unable to update your phone number.'
          end
        elsif not @tutor.update_attributes(:email => params[:email])
          raise 'Unable to save your email address.'
        end
      elsif session[:role] == 'student'
        @student = Student.find_by_sid(session[:username])
        if @student.nil?
          raise 'Unable to find user details.'
        elsif not @student.update_attributes(:first_name => params[:first_name])
          raise 'Unable to save your first name.'
        elsif not @student.update_attributes(:last_name => params[:last_name])
          raise 'Unable to save your last name.'
        elsif not params[:phone].blank?
          if not @student.update_attributes(:phone => params[:phone])
            raise 'Unable to update your phone number.'
          end
        elsif not @student.update_attributes(:email => params[:email])
          raise 'Unable to save your email address.'
        end
      end
    rescue Exception => e
      redirect_to :action => "change_details", :error => e.message
      return
    end
    
    # Save the password
    # This is invoke if the user enters a password
    if not params[:current_password].blank?
      user = User.authenticate(session[:username], params[:current_password]);
      if(not user.nil?)
        if(params[:new_password] == params[:confirm_password])
          if user.update_attributes(:password => params[:new_password])
            redirect_to :action => "change_details", :notice => "Password saved"
          else
            redirect_to :action => "change_details", :error => "Unable to change password"
          end
        else
          redirect_to :action => "change_details", :error => "New password does not match confirm password"
        end
      else
        redirect_to :action => "change_details", :error => "Wrong password"
      end
    else
      redirect_to :action => "change_details", :notice => "All details saved"
    end
  end
end
