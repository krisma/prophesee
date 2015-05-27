class CreateWatchings < ActiveRecord::Migration
  def change
    create_table :watchings do |t|
      t.belongs_to :user, index: true
      t.belongs_to :stock, index: true
      t.integer :attitude
      t.boolean :changeable
      
      t.timestamps null: false
    end
  end
end
