class WorkedTime < ApplicationRecord
	enum work_type:[:regular, :overtime]
  belongs_to :employee
end
