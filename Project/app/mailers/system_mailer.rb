class SystemMailer < ActionMailer::Base
  default from: "ackjmp@gmail.com"
  
  def registrationEmail(username, password, email, url)
    @username = username
    @password = password
    @url = url
    mail(:to => email, :subject => "Registered for Third Year Lab Booking System")
  end
  
  def passwordResetEmail(email, url)
    @url = url
    mail(:to => email, :subject => "Reset password for Third Year Lab Booking System")
  end

  def cancelBookingEmail (sid,email,experiment_name, url)
    @url = url
    @sid = sid
    @experiment_name = experiment_name    

    mail(:to => email, :subject => "following booking has been cancelled")
  end

  def makeBookingEmail (sid,email,experiment_name,experiment_dates, url)
    @sid = sid
    @url = url
    @experiment_name = experiment_name
    
    @experiment_dates = experiment_dates
    
    mail(:to => email, 
         :subject => "following lab has been booked for you")
  end
end

