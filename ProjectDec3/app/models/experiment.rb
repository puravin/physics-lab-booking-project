class Experiment < ActiveRecord::Base
  has_many :bookings, :dependent => :destroy
  has_many :marks, :dependent => :destroy
  has_many :experiment_availabilities, :dependent => :destroy
  
  validates :exp_num,      :presence => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validates :name,         :presence => true
  validates :num_sessions, :presence => true,                      :numericality => { :only_integer => true, :greater_than => 0 }
  validates :weight,       :presence => true,                      :numericality => { :only_integer => true, :greater_than => 0 }
end
