class CreateWorkedTimes < ActiveRecord::Migration[5.2]
  def change
    create_table :worked_times, id: :uuid do |t|
      t.date :date
      t.datetime :in_at
      t.datetime :out_at
      t.integer :duration, default: 0
      t.integer :overtime, default: 0
      t.belongs_to :employee, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
