class CreateConfigurations < ActiveRecord::Migration[5.2]
  def change
    create_table :configurations, id: :uuid do |t|
      t.integer :display_duration
      t.datetime :deployed_at
      t.datetime :subscribed_at

      t.timestamps
    end
  end
end
