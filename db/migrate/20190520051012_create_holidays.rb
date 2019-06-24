class CreateHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :holidays, id: :uuid do |t|
      t.string :name
      t.integer :holiday_type
      t.datetime :dated_at

      t.timestamps
    end
  end
end
