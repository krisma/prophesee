class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content
      t.date :date_created
      t.date :date_publish
      t.string :post_created
      t.string :post_publish
      t.boolean :active
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
