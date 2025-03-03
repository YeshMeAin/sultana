class AddLabelColumnsToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :is_popular, :boolean, default: false
    add_column :items, :is_new, :boolean, default: false
  end
end
