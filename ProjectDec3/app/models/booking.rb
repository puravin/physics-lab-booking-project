class Booking < ActiveRecord::Base
  belongs_to :experiment
  belongs_to :student
  belongs_to :user
  
  validates_uniqueness_of :date, :scope => [:experiment_id, :double_booked]
  
  # Store a booking into the database
  # It will update the booking stat
  #
  # sid: sid of the student
  # exp_num: exp_num of the experiment
  # date: a date object of when the experiment is booked
  # creator: username of the person who did the booking, usually session[:username]
  #
  # return true upon successful booking creation
  def self.makeBooking(student, exp_num, date, creator)
    experiment = Experiment.find_by_exp_num(exp_num)
    user = User.find_by_username(creator)
    
    # Check if double booked is allowed
    double_booked = experiment.double_booked
    booking = experiment.bookings.find_by_date(date)
    if (not double_booked) && (not booking.blank?)
      return false
    end
    
    # Save the booking
    if booking.blank?
      booking = new(:student => student, :experiment => experiment, :user => user, :date => date, :double_booked => false)
    else
      booking = new(:student => student, :experiment => experiment, :user => user, :date => date, :double_booked => (not booking.double_booked))
    end
    return booking.save
  end
end
