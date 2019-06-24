class CreateBusinessHours < ActiveRecord::Migration[5.2]
  def change
    create_table :business_hours, id: :uuid do |t|
      t.time :am_starts_at
      t.time :am_ends_at
      t.time :pm_starts_at
      t.time :pm_ends_at
      t.integer :employee_role

      t.timestamps
    end
  end
end
