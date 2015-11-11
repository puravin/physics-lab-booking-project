class PasswordReset < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, :uniqueness => true

  def self.resetPassword(user)
    rp = user.password_reset
    if rp.blank?
      rp = new
    end
    rp.user = user
    rp.token = SecureRandom.urlsafe_base64(32)
    rp.timestamp = DateTime.now
    rp.save!
    
    return rp.token
  end
  
  # Return true if the token is valid
  def self.confirmResetToken(user, token)
    rp = user.password_reset
    if rp.timestamp < 2.hours.ago
      rp.destroy
      return false
    end
    if rp.token != token
      return false
    end
    rp.destroy
    return true
  end
end
