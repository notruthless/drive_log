# == Schema Information
# Schema version: 20110610012744
#
# Table name: log_entries
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  night      :boolean
#  notes      :string(255)
#  start_time :datetime
#  end_time   :datetime
#  created_at :datetime
#  updated_at :datetime
#

class LogEntry < ActiveRecord::Base
  attr_accessible :night, :notes, :start_time, :end_time
  
  belongs_to :user
  
  validates :start_time, :presence => true
  validates :end_time, :presence => true
  validates :notes, :length => { :maximum => 250 }
  validates :user_id, :presence => true
  
  # we want them to be in order by start time, most recent first
  default_scope :order => 'log_entries.start_time DESC'
end
