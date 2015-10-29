class Calendar < ActiveRecord::Base
  def self.setAvailable(experiment_id, date, isAvailable)
    #retrieve record for given date
    record = find_by_experiment_id_and_date(experiment_id, date)

    if isAvailable
      return new(:date => date, :experiment_id => experiment_id).save
    else
      if not record.nil?
        return record.destroy
      end
    end
    
    return true
  end
  
  def self.isAvailable(date)
    record = find_by_date(date)
    return (not record.nil?)
  end

  def self.isAvailableExp(experiment_id, date)
    record = find_by_experiment_id_and_date(experiment_id, date)
    return (not record.nil?)
  end
end
