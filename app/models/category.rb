class Category < ApplicationRecord
  include ResourceAttributes

  has_many :items

  validates :display_name, :slug, presence: true

  def self.table_attributes
    [:display_name, :slug, :is_active, :sort_order, :description]
  end

  def self.show_attributes
    [:display_name, :slug, :is_active, :sort_order, :description, :updated_at, :created_at]
  end
end
