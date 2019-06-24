class CreateEmergencyContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :emergency_contacts, id: :uuid do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :relationship
      t.belongs_to :employee, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
