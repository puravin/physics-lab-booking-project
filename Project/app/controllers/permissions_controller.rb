class PermissionsController < ApplicationController
  def index
    @permissions = Permission.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @permissions }
    end
  end

  def update_permission
    @permissions = Permission.all
    @permissions.each { |permission|
      permission.admin = (not params[permission.class_name + "_admin"].nil?)
      permission.tutor = (not params[permission.class_name + "_tutor"].nil?)
      permission.student = (not params[permission.class_name + "_student"].nil?)
      if not permission.save
        respond_to do |format|
          format.html { render :action => "index" }
          format.xml  { render :xml => permission.errors, :status => :unprocessable_entity }
        end
      end
    }
    
    respond_to do |format|
      format.html { redirect_to :action => 'index', :notice => 'Permission was successfully updated.' }
      format.xml  { head :ok }
    end
  end
end
