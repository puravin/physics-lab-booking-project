class Permission < ActiveRecord::Base
  validates :class_name, :uniqueness => true
  
  def self.hasAccess(controller, role)
    result = where('class_name = ? AND ' << role << " = ?", controller, true)
    return result.length > 0
  end
end
