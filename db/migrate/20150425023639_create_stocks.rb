class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.references :item, index: true
      t.string :color
      t.string :size
      t.boolean :exist

      t.timestamps null: false
    end
    add_foreign_key :stocks, :items
  end
end
