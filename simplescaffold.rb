environment 'config.generators.assets = false'
environment 'config.generators.helper = false'
environment 'config.generators.test_framework = false'
environment 'config.generators.jbuilder = false'

file 'lib/generators/simple_scaffold/simple_scaffold_generator.rb', <<-'CODE'
require 'rails/generators/rails/resource/resource_generator'
require 'generators/simple_scaffold_controller/simple_scaffold_controller_generator'
module Rails
  module Generators
    class SimpleScaffoldGenerator < ResourceGenerator # :nodoc:
      remove_hook_for :resource_controller
      remove_class_option :actions

      class_option :stylesheets, type: :boolean, desc: "Generate Stylesheets"
      class_option :stylesheet_engine, desc: "Engine for Stylesheets"
      class_option :resource_route, type: :boolean #TRY ME

      def handle_skip
        @options = @options.merge(stylesheet_engine: false) unless options[:stylesheets]
      end

      invoke Rails::Generators::SimpleScaffoldControllerGenerator

      hook_for :assets do |assets|
        invoke assets, [controller_name]
      end
    end
  end
end
CODE
file 'lib/generators/simple_scaffold_controller/simple_scaffold_controller_generator.rb', <<-'CODE'
require 'rails/generators/resource_helpers'

module Rails
  module Generators
    class SimpleScaffoldControllerGenerator < NamedBase # :nodoc:
      include ResourceHelpers

      check_class_collision suffix: "Controller"

      class_option :orm, banner: "NAME", type: :string, required: true,
                         desc: "ORM to generate the controller for"

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def create_controller_files
        template "controller.rb", File.join('app/controllers', class_path, "#{controller_file_name}_controller.rb")
      end

      hook_for :template_engine, :test_framework, as: :scaffold
    end
  end
end
CODE

file 'lib/templates/rails/simple_scaffold_controller/controller.rb', <<-'CODE'
<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController

  def index
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>
    render 'index'
  end

  def show
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    render 'show'
  end

  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    render 'new'
  end

  def edit
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    render 'edit'
  end

  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

    if @<%= orm_instance.save %>
      redirect_to @<%= singular_table_name %>, notice: <%= "'#{human_name} was successfully created.'" %>
    else
      render action: 'new'
    end
  end

  def update
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      redirect_to @<%= singular_table_name %>, notice: <%= "'#{human_name} was successfully updated.'" %>
    else
      render action: 'edit'
    end
  end

  def destroy
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    @<%= orm_instance.destroy %>
    redirect_to <%= index_helper %>_url, notice: <%= "'#{human_name} was successfully destroyed.'" %>
  end

  private
    # Only allow a trusted parameter "white list" through.
    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params[<%= ":#{singular_table_name}" %>]
      <%- else -%>
      params.require(<%= ":#{singular_table_name}" %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end
end
<% end -%>
CODE