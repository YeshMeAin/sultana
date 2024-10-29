class CreateReceipes < ActiveRecord::Migration[7.1]
  def change
    create_table :receipes do |t|
      t.references :product, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.float :quantity
      t.text :instructions

      t.timestamps
    end
  end
end
