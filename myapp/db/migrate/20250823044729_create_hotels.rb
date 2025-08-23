class CreateHotels < ActiveRecord::Migration[8.0]
  def change
    create_table :hotels do |t|
      t.references :trip, null: false, foreign_key: true
      t.string :name
      t.string :url
      t.integer :price_cents
      t.string :currency

      t.timestamps
    end
  end
end
