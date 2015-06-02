class CreateStocks < ActiveRecord::Migration
  def change
    enable_extension 'hstore'
    create_table :stocks do |t|
      t.string :symbol
      t.string :name
      t.integer :up
      t.integer :down
      t.integer :neutral
      t.float :close
      t.float :change
      t.float :percent_change
      t.hstore :details
      t.datetime :details_exp
      t.hstore :five_d, array: true
      t.datetime :five_d_exp
      t.hstore :one_m, array: true
      t.datetime :one_m_exp
      t.hstore :six_m, array: true
      t.datetime :six_m_exp
      t.hstore :one_y, array: true
      t.datetime :one_y_exp
      t.hstore :all, array: true
      t.datetime :all_exp

      t.timestamps null: false
    end
  end
end
