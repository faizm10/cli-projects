class CreateTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :trips do |t|
      t.string :country
      t.integer :duration_days

      t.timestamps
    end
  end
end
