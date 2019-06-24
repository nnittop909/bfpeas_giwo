class AddFullNameToEmergencyContacts < ActiveRecord::Migration[5.2]
  def change
    add_column :emergency_contacts, :full_name, :string
  end
end
