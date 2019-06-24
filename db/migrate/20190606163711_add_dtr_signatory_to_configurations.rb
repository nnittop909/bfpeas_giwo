class AddDtrSignatoryToConfigurations < ActiveRecord::Migration[5.2]
  def change
    add_column :configurations, :dtr_signatory, :string
  end
end
