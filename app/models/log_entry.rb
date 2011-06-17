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

# Need to fix these to validate for actual time?
  validates :start_time, :presence => { :message => "must be a valid date/time" }
  validates :end_time, :presence => {:message => "must be a valid date/time"}
  validates :notes, :length => { :maximum => 250 }
  validates :user_id, :presence => true
  
  # we want them to be in order by start time, most recent first
  default_scope :order => 'log_entries.start_time DESC'
  
  # arrange to limit scope of returned items based on day/night
  scope :night, where(:night => true)
  scope :day, where(:night => false)
  
  # returns the elapsed time in minutes
  # I thought I could count on end_time and start_time being numeric, but apparently they are coming in as nil
  # after a failed log_entry creation.
  def elapsed_time
    if end_time && start_time
       return ((end_time - start_time)/60).round
    else
       return 0
    end
  end
end


