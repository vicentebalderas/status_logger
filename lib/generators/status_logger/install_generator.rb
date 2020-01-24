require 'rails/generators'
require 'rails/generators/migration'

module StatusLogger
  class InstallGenerator < ::Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path('../../templates',
                                 __FILE__)


    def self.next_migration_number(path)
      next_number = current_migration_number(path) + 1

      ActiveRecord::Migration.next_migration_number(next_number)
    end

    desc 'Copy migration'
    def copy_migration
      migration_template 'migrations/create_status_logs.rb',
                         'db/migrate/create_status_logs.rb'
    end

    desc 'Copy status logger model'
    def copy_model
      copy_file 'active_record/models/status_log.rb', 'app/models/status_log.rb'
    end
  end
end