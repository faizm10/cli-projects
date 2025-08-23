class CreateTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :trips do |t|
      t.string :country
      t.date :start_date
      t.date :end_date
      t.text :description

      t.timestamps
    end
  end
end
