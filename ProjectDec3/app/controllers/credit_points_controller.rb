class CreditPointsController < ApplicationController
  def index
    @credit_points = CreditPoint.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @credit_points }
    end
  end

  def update
    if params[:commit] == "Save"
      credit_point = CreditPoint.new(:cp => params[:cp], :experiment => params[:experiment], :report => params[:report], :poster => params[:poster], :talk => params[:talk], :assignment => params[:assignment])
      if credit_point.save
        redirect_to :action => "index", :notice => "Credit point was successfully created."
      else
        redirect_to :action => "index", :error => "Unable to save the credit point."
      end
    
    elsif params[:commit] == "Edit"
      credit_point = CreditPoint.find_by_cp(params[:cp])
      if credit_point.blank?
        redirect_to :action => "index", :error => "Unable to update the credit point."
        return
      end
      
      credit_point[:experiment] = params[:experiment]
      credit_point[:report] = params[:report]
      credit_point[:poster] = params[:poster]
      credit_point[:talk] = params[:talk]
      credit_point[:assignment] = params[:assignment]
      
      if credit_point.save
        redirect_to :action => "index", :notice => "Credit point was successfully edited."
      else
        redirect_to :action => "index", :error => "Unable to save the changed to credit point."
      end
    
    else
      redirect_to :action => "index", :error => "Invalid action."
    end
  end

  def destroy
    @credit_point = CreditPoint.find_by_cp(params[:cp])
    @credit_point.destroy

    redirect_to :action => "index", :notice => "Credit point was successfully deleted."
  end
end
