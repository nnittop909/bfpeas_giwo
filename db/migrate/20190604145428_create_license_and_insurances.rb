class CreateLicenseAndInsurances < ActiveRecord::Migration[5.2]
  def change
    create_table :license_and_insurances, id: :uuid do |t|
      t.string :pagibig_number
      t.string :sss_number
      t.string :phil_health_number
      t.string :prc_license_number
      t.string :tin_number
      t.belongs_to :employee, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
