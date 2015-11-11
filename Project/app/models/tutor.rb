class Tutor < ActiveRecord::Base
  attr_accessor :password
  
  validates :username, :uniqueness => true, :presence => true
  validates :first_name, :last_name, :presence => true
  validates :email, :uniqueness => true, :presence => true
  validates :phone, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }, :allow_blank => true # phone field is optional
  # please don't add any password validation here, add at the user table
  
end
