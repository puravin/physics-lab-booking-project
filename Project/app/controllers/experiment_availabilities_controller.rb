class ExperimentAvailabilitiesController < ApplicationController
  # GET /experiment_availabilities
  # GET /experiment_availabilities.xml
  def index
    @experiment_availabilities = ExperimentAvailability.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @experiment_availabilities }
    end
  end

  # GET /experiment_availabilities/1
  # GET /experiment_availabilities/1.xml
  def show
    @experiment_availability = ExperimentAvailability.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @experiment_availability }
    end
  end

  # GET /experiment_availabilities/new
  # GET /experiment_availabilities/new.xml
  def new
    @experiment_availability = ExperimentAvailability.new

    @experiments = {}
    Experiment.find(:all, :order => 'exp_num, id' ).each do |exp|
      @experiments["#{exp.exp_num}: #{exp.name}"] = exp.id
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @experiment_availability }
    end
  end

  # GET /experiment_availabilities/1/edit
  def edit
    @experiment_availability = ExperimentAvailability.find(params[:id])

    @experiments = {}
    Experiment.find(:all, :order => 'exp_num, id' ).each do |exp|
      @experiments["#{exp.exp_num}: #{exp.name}"] = exp.id
    end
  end

  # POST /experiment_availabilities
  # POST /experiment_availabilities.xml
  def create
    @experiment_availability = ExperimentAvailability.new(params[:experiment_availability])

    @experiments = {}
    Experiment.find(:all, :order => 'exp_num, id' ).each do |exp|
      @experiments["#{exp.exp_num}: #{exp.name}"] = exp.id
    end

    respond_to do |format|
      if @experiment_availability.save
        format.html { redirect_to(@experiment_availability, :notice => 'Changed exp day was successfully created.') }
        format.xml  { render :xml => @experiment_availability, :status => :created, :location => @experiment_availability }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @experiment_availability.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /experiment_availabilities/1
  # PUT /experiment_availabilities/1.xml
  def update
    @experiment_availability = ExperimentAvailability.find(params[:id])

    respond_to do |format|
      if @experiment_availability.update_attributes(params[:experiment_availability])
        format.html { redirect_to(@experiment_availability, :notice => 'Changed exp day was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @experiment_availability.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /experiment_availabilities/1
  # DELETE /experiment_availabilities/1.xml
  def destroy
    @experiment_availability = ExperimentAvailability.find(params[:id])
    @experiment_availability.destroy

    respond_to do |format|
      format.html { redirect_to(experiment_availabilities_url) }
      format.xml  { head :ok }
    end
  end
end
