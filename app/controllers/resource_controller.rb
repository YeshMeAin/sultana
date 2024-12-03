class ResourceController < ApplicationController
  def index
    instance_variable_set("@resources", resource_class.all)
    instance_variable_set("@resource_class", resource_class)
    instance_variable_set("@resource_name", resource_name)
    
    render 'shared/resource_index'
  end

  private

  def resource_class
    controller_name.classify.constantize
  end

  def resource_name
    controller_name.singularize
  end
end