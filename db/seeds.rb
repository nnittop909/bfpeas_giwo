school = School.find_or_create_by(
	name:         "Ifugao Academy, Inc.",
	code:         "IA",
	address:      "Poblacion, Kiangan, Ifugao"
)

Settings::Configuration.find_or_create_by(
	deployed_at: DateTime.new(2019, 5, 1) + 8.hours,
	subscribed_at: DateTime.new(2019, 5, 1) + 8.hours,
	display_duration: 10
)

BusinessHour.faculty_member.find_or_create_by(
	am_starts_at: Time.new(2000, 1, 1, 8, 0, 0, Time.zone),
	am_ends_at:   Time.new(2000, 1, 1, 12, 0, 0, Time.zone),
	pm_starts_at: Time.new(2000, 1, 1, 13, 0, 0, Time.zone),
	pm_ends_at:   Time.new(2000, 1, 1, 17, 0, 0, Time.zone)
)

BusinessHour.staff.find_or_create_by(
	am_starts_at: Time.new(2000, 1, 1, 8, 0, 0, Time.zone),
	am_ends_at:   Time.new(2000, 1, 1, 12, 0, 0, Time.zone),
	pm_starts_at: Time.new(2000, 1, 1, 13, 0, 0, Time.zone),
	pm_ends_at:   Time.new(2000, 1, 1, 17, 0, 0, Time.zone)
)

Employee.admin.create(
	first_name: "Admin", 
	last_name: "User", 
	email: "admin@ia.ph", 
	password: "11111111", 
	password_confirmation: "11111111",
	school: school,
	designation: "System Admin"
)