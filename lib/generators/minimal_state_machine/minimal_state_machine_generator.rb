require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

class MinimalStateMachineGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  desc "Creates migration files required by minimal state machine gem."

  self.source_paths << File.join(File.dirname(__FILE__), 'templates')

  def self.next_migration_number(path)
    ActiveRecord::Generators::Base.next_migration_number(path)
  end

  def create_migration_files
    create_migration_file_if_not_exist 'create_msm_states', '001'
  end

  private

  def create_migration_file_if_not_exist(file_name, version)
    unless self.class.migration_exists?(File.dirname(File.expand_path("db/migrate/#{file_name}")), file_name)
      migration_template "#{version}_#{file_name}.rb", "db/migrate/#{file_name}.rb"
    end
  end
end