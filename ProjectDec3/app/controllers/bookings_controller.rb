class BookingsController < ApplicationController
  def index
    # Student view for all their own experiment
    if session[:role] == 'student'
      sem_start   = Setting.getSetting('sem_start', 'date')
      sem_end     = Setting.getSetting('sem_end', 'date')
    
      @student = Student.find_by_sid(session[:username].to_i)
      @bookings = @student.bookings.where(:date => (sem_start .. sem_end)).order("date")
      
      render :template => 'bookings/student_view_booking.html.erb'
    else
      # Admin viewing the bookings as a giant calendar
    
      # Compute a hash of all dates in current semester
      sem_start   = Setting.getSetting('sem_start', 'date')
      sem_end     = Setting.getSetting('sem_end', 'date')
      
      dates_hash = Hash.new(nil) # default value for hash is nil
      Calendar.all.each do |date|
        dates_hash[date.date] = 0
      end
      ExperimentAvailability.where(:date => (sem_start .. sem_end)).each do |a|
        if a.is_available
          dates_hash[a.date] = 0
        end
      end
      
      @dates = dates_hash.keys
      @dates.sort!
      
      # Populate the hash with the column number
      for i in 0 .. (@dates.length - 1)
        dates_hash[@dates[i]] = i
      end
      
      # Genarate the calendar
      @experiment = Experiment.all
      @calendar = Array.new(@experiment.length)
      
      for i in 0 .. (@experiment.length - 1)
        array = Array.new(@dates.length)
        @calendar[i] = array
        
        @experiment[i].bookings.each do |b|
          index = dates_hash[b.date]
          if index.nil?
            next
          end
          if array[index].nil?
            array[index] = Array.new
          end
          array[index] << b
        end
      end
      
      render :template => 'bookings/admin_view_booking.html.erb'
    end
  end
end
