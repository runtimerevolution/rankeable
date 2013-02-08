require 'rails/generators/active_record'

module Rails
  module Generators
    class RankeableGenerator < ActiveRecord::Generators::Base
    	argument  :attributes, 
                :type => :array, 
                :default => [], 
                :banner => "field:type field:type"

      source_root File.expand_path("../templates", __FILE__)

      def join_rankeable_logic_with_migration
        unless (behavior == :invoke && model_already_exists?)
          migration_template "migration.rb", "db/migrate/create_#{table_name}"
        end
      end

      def generate_model
        unless model_already_exists? && behavior == :invoke
          invoke "active_record:model", [name], :migration => false 
        end
      end

      def inject_rankeable_content
        content = model_content
        class_path = namespaced?? class_name.to_s.split("::") : [class_name]
        content = format_content_depth(content, class_path.size - 1)
        inject_into_class(model_path, class_path.last, content) if model_already_exists?
      end

      private 

      def format_content_depth(content, indent_depth)
        return content.split("\n").map { |line| 
                    "  " * indent_depth + line 
                  }.join("\n") << "\n"
      end

      def model_already_exists?
        File.exists?(File.join(destination_root, model_path))
      end
          
      def migration_path
        @migration_path ||= File.join("db", "migrate")
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end

      def model_content
<<CONTENT
  # Injected by Rankeable Gem
  is_rankeable
CONTENT
      end
  	end
  end
end