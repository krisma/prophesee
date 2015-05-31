class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.integer :up
      t.integer :down
      t.integer :neutral

      t.timestamps null: false
    end
  end
end
