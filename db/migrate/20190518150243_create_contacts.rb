class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts, id: :uuid do |t|
      t.string :number
      t.boolean :default, default: false
      t.references :contactable, polymorphic: true, index: true, type: :uuid

      t.timestamps
    end
  end
end
