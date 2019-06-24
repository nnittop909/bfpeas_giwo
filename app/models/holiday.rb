class Holiday < ApplicationRecord
	enum holiday_type: [:regular, :special]
end
