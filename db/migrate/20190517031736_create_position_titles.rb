class CreatePositionTitles < ActiveRecord::Migration[5.2]
  def change
    create_table :position_titles, id: :uuid do |t|
      t.string :name
      t.boolean :default, default: false
      t.integer :placement
      t.belongs_to :employee, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
