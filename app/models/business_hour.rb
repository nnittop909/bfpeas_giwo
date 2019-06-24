class BusinessHour < ApplicationRecord
	enum employee_role:[:faculty_member, :staff, :security_personel]

	def self.am_pm
		am.all + pm.all
	end

	def am_starts
    time_parse(am_starts_at)
  end

  def am_ends
    time_parse(am_ends_at)
  end

  def pm_starts
    time_parse(pm_starts_at)
  end

  def pm_ends
    time_parse(pm_ends_at)
  end

  def total_minutes
    (((am_starts - am_ends) + (pm_starts - pm_ends)) / 1.minutes).abs.ceil
  end

  def total_working_hours
    (total_minutes.to_f / 60).to_s.split(".").first.to_i
  end

  def total_working_minutes
    (total_minutes - (total_working_hours*60))
  end

  private
  def time_parse(time)
    Time.new(2000, 1, 1, time.hour, time.min, 0, Time.zone)
  end

end
