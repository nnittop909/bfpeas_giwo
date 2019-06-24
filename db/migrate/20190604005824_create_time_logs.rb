class CreateTimeLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :time_logs, id: :uuid do |t|
      t.datetime :logged_at
      t.integer :status
      t.belongs_to :employee, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
