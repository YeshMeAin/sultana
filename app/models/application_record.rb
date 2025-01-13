class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :index_order, -> { order(id: :desc) }

  def self.table_attributes
    # Override in each model
    []
  end

  def self.show_attributes
    # Override in each model
    []
  end

  def self.associated_collections
    # Override in each model
    []
  end
end
