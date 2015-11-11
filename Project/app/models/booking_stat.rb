class BookingStat < ActiveRecord::Base
  belongs_to :user
  
  def self.getStat(user)
    stat = user.booking_stat
    if stat.blank?
      stat = create(user)
      stat.save
      return stat
    end
    stat = validateExpireDate(stat)
    stat = validateSemester(stat)
    stat.save
    return stat
  end
  
  # return true when success
  def self.increaseBookingCount(user, weight)
    stat = user.booking_stat
    if stat.blank?
      stat = create(user)
    end
    
    stat = validateExpireDate(stat)
    stat = validateSemester(stat)
    stat[:bookingCount] += weight
    stat[:semesterExpCount] += weight
    stat[:totalExpCount] += weight
    return stat.save
  end
  
  # return true when success
  def self.decreaseBookingCount(user, weight)
    stat = user.booking_stat
    stat = validateExpireDate(stat)
    stat = validateSemester(stat)
    stat[:bookingCount] -= weight
    stat[:semesterExpCount] -= weight
    stat[:totalExpCount] -= weight
    stat[:bookingCount] = 0 if stat[:bookingCount] < 0
    stat[:semesterExpCount] = 0 if stat[:semesterExpCount] < 0
    stat[:totalExpCount] = 0 if stat[:totalExpCount] < 0
    return stat.save
  end
  
private
  def self.create(user)
    expireDate = Date.today
    expireDate += expireDate.wday
    sem_start = Setting.getSetting('sem_start', 'date')
    return BookingStat.new(:user => user, :bookingCount => 0, :expire => expireDate, :semesterExpCount => 0, :semesterStart => sem_start, :totalExpCount => 0)
  end

  def self.validateExpireDate(stat)
    expireDate = Date.today
    expireDate += expireDate.wday
    if (stat.expire <=> expireDate) < 0
      stat[:bookingCount] = 0
      stat[:expire] = expireDate
    end
    return stat
  end
  
  def self.validateSemester(stat)
    sem_start = Setting.getSetting('sem_start', 'date')
    return stat
  end
end
