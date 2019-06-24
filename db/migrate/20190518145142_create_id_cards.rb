class CreateIdCards < ActiveRecord::Migration[5.2]
  def change
    create_table :id_cards, id: :uuid do |t|
      t.string :id_number
      t.integer :rfid_uid
      t.boolean :default, default: false
      t.belongs_to :employee, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
