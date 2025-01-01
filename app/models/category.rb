class Category < ApplicationRecord
  include ResourceAttributes

  has_many :items

  def self.table_attributes
    [:display_name, :slug, :is_active, :sort_order]
  end

  def self.show_attributes
    [:display_name, :slug, :is_active, :sort_order, :updated_at, :created_at]
  end
end
