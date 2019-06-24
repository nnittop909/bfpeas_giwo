class AddScheduleIdToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_reference :employees, :schedule, foreign_key: true, type: :uuid
  end
end
