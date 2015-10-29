class ViewBookingController < ApplicationController
  def index
	sbookings = Booking.find(:all, :include => :experiment, :include => :student)
	@bookings = []
	sbookings.each do |b|
		if b.student.sid = session[:username]
			@bookings << b
		end
	end
	
	respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @view_booking }
    end
  end
end
