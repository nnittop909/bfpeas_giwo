class OvertimeConfig < ApplicationRecord
	enum applies_to: [:all_employees, :faculty_member, :staff]
end
