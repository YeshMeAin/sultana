class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.table_attributes
    # Override in each model
    []
  end

  def self.show_attributes
    # Override in each model
    []
  end
end
