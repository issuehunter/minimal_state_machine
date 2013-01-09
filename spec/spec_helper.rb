require 'minimal_state_machine'
require 'debugger'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.up("lib/generators/minimal_state_machine/templates")
ActiveRecord::Migration.create_table :state_machines

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end