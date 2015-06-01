class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.string :name
      t.integer :up
      t.integer :down
      t.integer :neutral
      t.float :change
      t.float :percent_change
      t.hstore :details

      t.timestamps null: false
    end
  end
end
