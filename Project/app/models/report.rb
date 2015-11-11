class Report < ActiveRecord::Base
  has_attached_file :report
  belongs_to :user
end
