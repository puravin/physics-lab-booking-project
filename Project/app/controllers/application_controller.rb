class ApplicationController < ActionController::Base
  before_filter :login_user
  before_filter :check_permission
  protect_from_forgery
  layout 'application'

  protected
    def login_user
      if(session[:id].nil?)
        session[:return_to] = "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
        redirect_to :controller => "login", :error => "Please login first"
      end
    end 
    
    def check_permission
      begin
        if session[:role].nil?
          raise
        end
        
        if session[:role] != 'admin'
          # In case the user isn't admin, have to check the user permission for the page
          userPermission = Permission.find_by_class_name(self.class.name)
          if userPermission.nil?
            raise
          end
          if not userPermission[session[:role]]
            raise
          end
        end
        
        # Compute the menu list
        @menu_list = Permission.where(session[:role] + " = ?", true)

      rescue
        render :status => :forbidden, :text => "You have no permission to access this page."
      end
    end
end
