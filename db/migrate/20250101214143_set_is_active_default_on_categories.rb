class SetIsActiveDefaultOnCategories < ActiveRecord::Migration[7.1]
  def change
    change_column_default :categories, :is_active, true
  end
end
