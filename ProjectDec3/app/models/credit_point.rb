class CreditPoint < ActiveRecord::Base
  validates :cp,         :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validates :experiment, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validates :report,     :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validates :poster,     :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validates :talk,       :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validates :assignment, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
end

