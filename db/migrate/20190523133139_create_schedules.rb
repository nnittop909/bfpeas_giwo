class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules, id: :uuid do |t|
      t.string :name
      t.integer :shift_type
      t.time :starts_at
      t.time :ends_at

      t.timestamps
    end
  end
end
