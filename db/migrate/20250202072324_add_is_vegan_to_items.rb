class AddIsVeganToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :is_vegan, :boolean, default: false
  end
end
