class CreateOvertimeConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :overtime_configs, id: :uuid do |t|
      t.integer :minimum_overtime, default: 0
      t.integer :applies_to
      t.time :starts_at
      t.time :ends_at

      t.timestamps
    end
  end
end
