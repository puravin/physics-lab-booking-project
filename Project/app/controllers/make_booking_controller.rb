class MakeBookingController < ApplicationController

  def index
    if session[:role] == 'student'
      # Booking statistics
      user = User.find_by_username(session[:username])
      booking_stat = BookingStat.getStat(user)
      @weekly_booking = booking_stat.bookingCount
      @max_weekly_booking = Setting.getSetting('max_booking', 'integer')
      @max_semester_booking = 2*CreditPoint.find_by_cp(Student.find_by_sid(user.details_id).cp).experiment

      # Validate student
      @student = Student.find_by_sid(session[:username])
    elsif not params[:student_id].blank?
      @student = Student.find(params[:student_id])
    end

    #changed to count the number of bookings
    @semester_booking = @student.bookings.count(:experiment_id, distinct: true)
    # gets the sessions booked for the student
    @current_sessions = @student.bookings.count(:all)
    
    # Student doesn't exist
    if @student.nil?
      render :status => :forbidden, :text => "Unable to find the student."
      return
    end
    
    # Get all available experiment
    @experiments = Experiment.where(:available => true)

    # Get student status to each experiment
    if not @experiments.empty?
      @experiment_status = Array.new

      for i in 0 .. (@experiments.length - 1) do

        bookings = Booking.where(:student_id => @student.id, :experiment_id => @experiments[i].id)
        @experiment_status << 'nothing'
        
        # if latest booked date is before today's date, status is complete
        if not bookings.empty?
          @experiment_status[i] = 'complete'

          bookings.each do |book|
            if not book.date.past?
              @experiment_status[i] = 'booked'
              break
            end
          end
        end
      end
    end
    
    # Render page
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @experiments }
    end
  end
  
  def view_experiment
    @experiment = Experiment.find(params[:experiment_id])
    @student = Student.find(params[:student_id])
    #gets all the bookings made by the student for the current experiment => allows to delete the experiment selected (used in the view)
    @bookings_exp = @experiment.bookings.where(:student_id => params[:student_id])
    
    # Check if the student ID is valid
    # Also check if the user has the permission to access
    if @student.nil? || (session[:role] == 'student' && session[:username] != @student.sid)
      render :status => :forbidden, :text => "You have no permission to make booking."
      return
    end
    
    # Check if the experiment is available for the student
    if @experiment.blank? || @experiment.available ==  false
      render :status => :forbidden, :text => "The selected experiment doesn't exist."
      return
    end
    
    # Compute a hash of all dates that's available for booking
    available_date = Hash.new
    Calendar.where(:experiment_id => params[:experiment_id]).each do |date|
      available_date[date.date] = 0
    end
    @experiment.experiment_availabilities.each do |a|
      if a.is_available
        available_date[a.date] = 0
      else
        available_date[a.date] = nil
      end
    end
    
    # Get all the booking made
    # -1 in the available_date table indicates the booking is made by the user themselves
    sid = @student.sid
    @earliest_date = nil
    @min_day_cancel_booking = Setting.getSetting('min_day_cancel_booking', 'integer')
    @bookings = []
    # changed from individual experiment to get all bookings for a student
    @student.bookings.each do |b|
      if b.student.sid == sid
        available_date[b.date] = -1
        # checks to see if there is a booking made by the student for the currently selected experiment
        if @experiment.bookings.where(:date => b.date).length > 0 
          @earliest_date = b.date
        end
        @bookings << b
      elsif (not available_date[b.date].nil?) && available_date[b.date] >= 0
        available_date[b.date] += 1
      end
    end

    #checks the booked dates made by other students for the current experiment
    @experiment.bookings.each do |b|
      if b.student.sid != sid
        if @experiment.bookings.where(:date => b.date).length > 0
          #the date is made unavailable on the current student's experiment booking calendar
          available_date[b.date] = 2
        end
      end
    end
    
    # Generate a calendar for booking
    start_date = Date.today - (Date.today.wday)
    end_date = Setting.getSetting('sem_end', 'date')
    end_date += 6 - end_date.wday
    
    max_booking = @experiment.double_booked ? 2 : 1
    
    @dates = Array.new
    current_row = Array.new
    @dates << current_row
    
    for i in start_date .. end_date
      if current_row.length >= 7
        current_row = Array.new
        @dates << current_row
      end
      if available_date[i].nil?
        current_row << [i.to_s, "disabled"]
      elsif available_date[i] < 0
        current_row << [i.to_s, "booked"]
      elsif (i <=> Date.today) <= 0
        current_row << [i.to_s, "disabled"]
      elsif available_date[i] < max_booking
        current_row << [i.to_s, "available"]
      else
        current_row << [i.to_s, "unavailable"]
      end
    end
  end
  
  def update_booking
    begin
      experiment = Experiment.find(params[:experiment_id])
      student = Student.find(params[:student_id])

      
      # Check if the student is valid
      if student.nil? || (session[:role] == 'student' && session[:username] != student.sid)
        render :status => :forbidden, :text => "You have no permission to make booking."
        return
      end
      
      # Check if the experiment is available for the student
      if experiment.blank? || experiment.available ==  false
        render :status => :forbidden, :text => "The selected experiment doesn't exist."
        return
      end
      
      # Book experiment
      if params[:commit] == "Book Experiment"
        # Check if exceed max booking number

        if session[:role] == 'student'
          user = User.find_by_username(session[:username])
          #count current amount of bookings made
          booked_sessions = student.bookings.count(:all)
          max_sem_sessions = 2*CreditPoint.find_by_cp(Student.find_by_sid(user.details_id).cp).experiment
         # booked_sessions = @user.bookings.where(:student_id => params[:student_id]).count
          #booked_sessions = Booking.count(:student_id => params[student_id])
          #max_booking = Setting.getSetting('max_booking', 'integer')
          if booked_sessions + experiment.num_sessions > max_sem_sessions
            raise "Unable to make booking as it exceeds max number of sessions available. Please contact the administrator."
          end
          if booked_sessions > max_sem_sessions
            raise "You reached the cap for the number of bookings this semester."
          end
        end
        
        # Get all the dates for the current booking
        dates = []
        params.each do |key, value|
          if value == "checked"
            dates << Date.parse(key)
          end
        end
        dates.sort!

		# Checks to make sure that a student cannot book two different experiment  in one week
    if session[:role]=='student'
      sid = student.sid
      eid = params[:experiment_id]
      @bookings = []
      student.bookings.each do |b|
        
       for i in 1 .. (dates.length - 1)
        if (b.date.cweek == dates[i].cweek) || ((b.date + 7).cweek == dates[i].cweek)
          raise "Can not book in a week you have already booked"
        end
      end
    end
		
		end
		
        # Check to ensure student can only make one session booking per day 
        dates.each do |date|
          if student.bookings.find_by_date(date) != nil
            raise "Booking already made on " + date.to_s + '. Please select alternative days'
          end
        end

        
        
        # Check the number of session matched the required session for the experiment
        if dates.length != experiment.num_sessions
          raise 'Please select ' + experiment.num_sessions.to_s + ' sessions only'
        end

        # Validate the bookings
        if params[:session][:num] == '1'
          week = dates[0].cweek
          for i in 1 .. (dates.length - 1)
            if dates[i].cweek != week + 1
              raise 'Sessions must be in consecutive weeks'
            end
            week += 1
          end
        elsif params[:session][:num] == '2'
          week = dates[0].cweek - 1
          for i in 0 .. (dates.length / 2 - 1)
            if dates[i * 2].cweek != dates[i * 2 + 1].cweek
              raise 'Sessions must be in same week'
            elsif dates[i * 2].cweek != week + 1
              raise 'Sessions must be in consecutive weeks'
            end
            week += 1
          end
        else
          for date in dates[0] .. dates[dates.length - 1]
            if not dates.include?(date)
              is_lab_open = Calendar.find_by_date(date) != nil
              is_experiment_available = ExperimentAvailability.where(:date => date, :is_available => true).length > 0
              if is_lab_open || is_experiment_available
                raise 'Sessions must be on consecutive lab days'
              end
            end
          end
        end
        
        # Save bookings
        success = true
        Booking.transaction do
          dates.each do |date|
            if not Booking.makeBooking(student, experiment.exp_num, date, session[:username])
              success = false
              raise ActiveRecord::Rollback
            end
          end
        end
        
        if success
          # Increase the booking count for the student
          if session[:role] == 'student'
            user = User.find_by_username(session[:username])
            BookingStat.increaseBookingCount(user, experiment.weight)
          end

          SystemMailer.makeBookingEmail(student.sid, student.email,experiment.name,dates, root_url).deliver
          redirect_to :action => "view_experiment", :notice => 'Booking is successfully made', :experiment_id => experiment, :student_id => student
        else
          raise 'Unable to save one of the bookings'
        end
        
      elsif params[:commit] == "Delete Bookings"
        params.each do |key, value|
          if value == "unbook"
            booking = Booking.find(key.to_i)
            if not booking.destroy
              raise 'Unable to delete some of the bookings'
            end
          end
        end
        
        # Increase the booking count for the student
        if session[:role] == 'student'
          BookingStat.decreaseBookingCount(User.find_by_username(session[:username]), experiment.weight)
        end

        SystemMailer.cancelBookingEmail(student.sid, student.email,experiment.name,root_url).deliver
        redirect_to :action => "view_experiment", :notice => 'Bookings are successfully deleted', :experiment_id => experiment, :student_id => student
      end
    end
  rescue Exception => e
    redirect_to :action => "view_experiment", :error => e, :experiment_id => experiment, :student_id => student
    return
  end
end
