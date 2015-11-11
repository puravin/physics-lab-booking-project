class User < ActiveRecord::Base
  has_many :bookings,       :dependent => :destroy
  has_many :marks,          :dependent => :destroy
  has_many :reports,        :dependent => :destroy
  has_one  :booking_stat,   :dependent => :destroy
  has_one  :password_reset, :dependent => :destroy
  
  require 'digest/md5'
  validates :username, :uniqueness => true
  validates :password, :confirmation => true, :length => { :in => 5..20 }
  validates :role, :inclusion => { :in => %w(admin tutor student), :message => "%{value} is not a valid role" }
  before_save :cipher_password!
  
  # If a user matching the credentials is found, returns the User object
  # If no matching user is found, returns nil
  def self.authenticate(username, password)
    user = find_by_username(username)
    if((not user.nil?) && (Digest::MD5.hexdigest(password).to_s == user[:password]))
      return user
    else
      return nil
    end
  end
  
  private
    def cipher_password!
      write_attribute("password", Digest::MD5.hexdigest(password).to_s)
    end
end