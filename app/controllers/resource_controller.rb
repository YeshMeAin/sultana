class ResourceController < ApplicationController
  include ActionView::RecordIdentifier
  
  before_action :set_resource, only: %i[ show edit update destroy ]
  before_action :set_resource_class_and_name

  def index
    instance_variable_set("@resources", resource_class.all)
    
    render 'shared/resource_index'
  end

  def show
    respond_to do |format|
      format.turbo_stream
      format.html { render partial: 'shared/show_modal', locals: { resource: @resource } }
    end
  end

  def new
    @resource = resource_class.new
    respond_to do |format|
      format.turbo_stream
      format.html { render partial: 'shared/new_modal', locals: { resource: @resource } }
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream
      format.html { render partial: 'shared/edit_modal', locals: { resource: @resource } }
    end
  end

  def destroy
    @resource.destroy!

    respond_to do |format|
      format.html { redirect_to url_for(controller: controller_name, action: :index), notice: "#{resource_name.titleize} was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def create
    @resource = resource_class.new(trusted_params)

    respond_to do |format|
      if @resource.save
        format.turbo_stream { 
          render turbo_stream: [
            turbo_stream.update("#{controller_name}", partial: "shared/resource_table", locals: { resources: resource_class.all, resource_class: @resource_class }),
            turbo_stream.update("modal_content", ""),
            turbo_stream.replace("modal_backdrop", 
              '<div id="modal_backdrop" class="modal-backdrop fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity hidden" data-resource-table-target="modalBackdrop" data-action="click->resource-table#closeModal"></div>'
            ),
            turbo_stream.replace("flash", 
              render_to_string(partial: "shared/flash", locals: { notice: "#{resource_name.titleize} was successfully created." })
            )
          ]
        }
        format.html { redirect_to url_for(controller: controller_name, action: :index), notice: "#{resource_name.titleize} was successfully created." }
      else
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("flash", 
              render_to_string(partial: "shared/flash", locals: { alert: @resource.errors.full_messages.join(', ') })
            )
          ]
        }
        format.html { render partial: 'shared/new_modal', locals: { resource: @resource } }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @resource.update(trusted_params)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.update("#{controller_name}", partial: "shared/resource_table", locals: { resources: resource_class.all }),
            turbo_stream.update("modal_content", ""),
            turbo_stream.update("modal_backdrop", ""),
            turbo_stream.prepend("flash", partial: "shared/flash", locals: { notice: "#{resource_name.titleize} was successfully updated." })
          ]
        }
        format.html { redirect_to url_for(controller: controller_name, action: :index), notice: "#{resource_name.titleize} was successfully updated." }
      else
        format.turbo_stream { render partial: "shared/edit_modal", locals: { resource: @resource } }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_resource_class_and_name
    @resource_class = resource_class
    @resource_name = resource_name
  end

  def set_resource
    @resource = resource_class.find(params[:id])
  end

  def resource_class
    controller_name.classify.constantize
  end

  def resource_name
    controller_name.singularize
  end

  def resource_path(resource)
    send("#{resource_name}_path", resource)
  end

  def edit_resource_path(resource)
    send("edit_#{resource_name}_path", resource)
  end

  def new_resource_path
    send("new_#{resource_name}_path")
  end

  def trusted_params
    params.require(resource_name.to_sym).permit(resource_class.table_attributes)
  end
  
  # Make these helpers available to views
  helper_method :resource_path, :edit_resource_path, :new_resource_path
end
