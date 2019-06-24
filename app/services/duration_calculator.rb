class DurationCalculator

	def initialize(in_at, out_at, starts_at, ends_at)
		@in_at = in_at
		@out_at = out_at
		@starts_at = starts_at
		@ends_at   = ends_at
	end

	def duration
		time_to = @out_at > @ends_at ? @ends_at : @out_at
		time_from = @starts_at > @in_at ? @starts_at : @in_at
		total_minutes = ((time_to - time_from) / 1.minutes).abs.to_i
		get_hours = (total_minutes.to_f / 60).to_s.split(".").first.to_i
		get_minutes = (total_minutes - (get_hours*60)).to_i
		hour_unit         = get_hours == 1    ? "hour" : "hours"
    min_unit          = get_minutes == 1  ? "min." : "mins."
    hours_with_unit   = get_hours.zero?   ? nil    : "#{get_hours} #{hour_unit}"
    minutes_with_unit = get_minutes.zero? ? nil    : "#{get_minutes} #{min_unit}"
    [hours_with_unit, minutes_with_unit].compact.join(", ")
	end
end