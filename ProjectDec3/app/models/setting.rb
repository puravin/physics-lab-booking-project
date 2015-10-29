class Setting < ActiveRecord::Base
  # type can be
  #  - string
  #  - integer
  #  - decimal
  #  - date
  
  validates :name, :uniqueness => true
  
  # Set the particular type of setting to the given value
  # multiple type for a setting can be used
  # this will override the old value of the given type
  def self.setSetting(name, type, value)
    setting = find_by_name(name)
    if setting.nil?
      setting = new(:name => name, :string =>  nil, :integer => nil, :decimal => nil, :date => nil)
    end
    
    setting[type] = value
    return setting.save
  end
  
  # Get the value for the given name and type
  def self.getSetting(name, type)
    setting = find_by_name(name)
    if setting.nil?
      return nil
    end
    return setting[type]
  end
end
