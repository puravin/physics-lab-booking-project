class ExperimentAvailability < ActiveRecord::Base
  belongs_to :experiment
  
  validates_uniqueness_of :date, :scope => :experiment_id
end
