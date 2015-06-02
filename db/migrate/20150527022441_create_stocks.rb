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
      t.datetime :details_exp
      t.hstore :five_d
      t.datetime :five_d_exp
      t.hstore :one_m
      t.datetime :one_m_exp
      t.hstore :six_m
      t.datetime :six_m_exp
      t.hstore :one_y
      t.datetime :one_y_exp
      t.hstore :all
      t.datetime :all_exp

      t.timestamps null: false
    end
  end
end
