class TimeLog < ApplicationRecord
	enum status:[:logged_in, :logged_out]
  belongs_to :employee
  before_save :parse_log_time

  private
  def parse_log_time
  	self.logged_at = Time.new(logged_at.year, logged_at.month, logged_at.day, logged_at.hour, logged_at.min, 0, Time.zone)
  end
end
