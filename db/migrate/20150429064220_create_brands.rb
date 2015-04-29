class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.references :site, index: true
      t.string :name
      t.integer :priority

      t.timestamps null: false
    end
  end
end
