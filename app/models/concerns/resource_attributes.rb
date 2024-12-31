module ResourceAttributes
  extend ActiveSupport::Concern

  class_methods do
    def table_attributes
      []
    end

    def show_attributes
      []
    end
  end

  def self.available_resources
    Rails.application.eager_load!
    ApplicationRecord.descendants.select do |model|
      model.respond_to?(:table_attributes) &&
        model.table_attributes.any? &&
        model.show_attributes.any?
    end.sort_by(&:name)
  end

  def associated_collections
    []
  end

end