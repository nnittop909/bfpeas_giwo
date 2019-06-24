class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses, id: :uuid do |t|
      t.string :sitio
      t.string :barangay
      t.string :municipality
      t.string :province
      t.string :full_details
      t.boolean :default, default: false
      t.references :addressable, polymorphic: true, index: true, type: :uuid

      t.timestamps
    end
  end
end
