class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :title
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end
    # add_index :products, :title, unique: true
  end
end
