class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title, null: false, index: true
      t.string :url, null: false
      t.integer :original_price
      t.boolean :discounted
      t.integer :discount_price
      t.text :description
      t.string :image

      t.timestamps null: false
    end
  end
end
