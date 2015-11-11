class TutorsController < ApplicationController
  # GET /tutors
  # GET /tutors.xml
  def index
    @tutors = Tutor.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tutors }
    end
  end

  # GET /tutors/1
  # GET /tutors/1.xml
  def show
    @tutor = Tutor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tutor }
    end
  end

  # GET /tutors/new
  # GET /tutors/new.xml
  def new
    @tutor = Tutor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tutor }
    end
  end

  # GET /tutors/1/edit
  def edit
    @tutor = Tutor.find(params[:id])
  end

  # POST /tutors
  # POST /tutors.xml
  def create
    @tutor = Tutor.new(params[:tutor])
    @user = User.new(:username => params[:tutor][:username], :password => params[:tutor][:password], :role => "tutor", :details_id => params[:tutor][:username]);

    # Trying to save the data
    save_success = true
    Tutor.transaction do
      if (not @tutor.save) || (not @user.save)
        save_success = false
        raise ActiveRecord::Rollback
      end
    end
    
    respond_to do |format|
      if save_success
        # Send an email to the user regarding the registration
        SystemMailer.registrationEmail(@user.username, params[:tutor][:password], @tutor.email, root_url).deliver
        
        format.html { redirect_to(@tutor, :notice => 'Tutor was successfully created.') }
        format.xml  { render :xml => @tutor, :status => :created, :location => @tutor }
      else
        @user.errors.each {|attr, msg|
          @tutor.errors.add(attr, msg)
        }
        format.html { render :action => "new" }
        format.xml  { render :xml => @tutor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tutors/1
  # PUT /tutors/1.xml
  def update
    @tutor = Tutor.find(params[:id])

    respond_to do |format|
      if @tutor.update_attributes(params[:tutor])
        format.html { redirect_to(@tutor, :notice => 'Tutor was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tutor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tutors/1
  # DELETE /tutors/1.xml
  def destroy
    @tutor = Tutor.find(params[:id])
    @user = User.find_by_username(@tutor.username)
    @tutor.destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(tutors_url) }
      format.xml  { head :ok }
    end
  end
end
