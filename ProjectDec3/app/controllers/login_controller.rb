class LoginController < ApplicationController
  skip_before_filter :login_user
  skip_before_filter :check_permission
  
  def index
    if session[:username].nil?
      @user = User.new
      @user.username = params[:username]
    
      # surpass the layout frame
      render :layout => false
    else
      redirect_to :controller => "home", :action => "index"
    end
  end

  def validate
    user = User.authenticate(params[:username], params[:password]);
    if(not user.nil?)
      session[:username] = user.username
      session[:id] = user.details_id
      session[:role] = user.role
      if(session[:return_to])
        redirect_to session[:return_to]
      else
        redirect_to :controller => "home", :action => "index"
      end
    else
      redirect_to :action => "index", :username => params[:username], :error => "Invalid login"
    end
  end
  
  def logout
    reset_session
    redirect_to :action => "index", :notice => "Logged out"
  end
  
  # Forget password page
  def forget_password
    # surpass the layout frame
    render :layout => false
  end
  
  # Send password reset email
  def send_password_reset
    # Find the associate user
    detail = Student.find_by_email(params[:email])
    user = nil
    if detail.blank?
      detail = Tutor.find_by_email(params[:email])
      if not detail.blank?
        user = User.find_by_username(detail.username)
      end
    else
      user = User.find_by_username(detail.sid)
    end
    if user.blank?
      redirect_to :action => "forget_password", :error => "Cannot find any user registered with the given email."
      return
    end
    
    # get the token and send the user the password reset email
    token = PasswordReset.resetPassword(user)
    url = "#{request.protocol}#{request.host_with_port}/login/password_reset?token=#{token}&username=#{user.username}"
    SystemMailer.passwordResetEmail(params[:email], url).deliver
    redirect_to :action => "index", :notice => "Email sent with password reset instructions."
  end

  def password_reset
    @username = params[:username]
    @token = params[:token]
    render :layout => false
  end
  
  def password_reset_update
    begin
      user = User.find_by_username(params[:username])
      if user.blank? || params[:token].blank?
        raise
      end
      if PasswordReset.confirmResetToken(user, params[:token]) && user.update_attributes(:password => params[:new_password])
        redirect_to :action => "validate", :username => params[:username], :password => params[:new_password]
      else
        raise
      end
    rescue
      redirect_to :action => "index", :error => 'Unable to reset password'
    end
  end
end
