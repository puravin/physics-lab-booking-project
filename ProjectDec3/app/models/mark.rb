class Mark < ActiveRecord::Base
  belongs_to :experiment
  belongs_to :student
  belongs_to :user
  
  validates :mark_type, :inclusion => { :in => %w(experiment report poster talk assignment), :message => "%{value} is not a valid mark type" }
end

