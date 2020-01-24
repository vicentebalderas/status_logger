MIGRATION_CLASS =
  if ActiveRecord::VERSION::MAJOR >= 5
    ActiveRecord::Migration["#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}"]
  else
    ActiveRecord::Migration
  end

class CreateStatusLogs < MIGRATION_CLASS
  def change
    create_table :status_logs do |t|
      t.bigint :status_loggeable_id
      t.string :status_loggeable_type
      t.string :status_attribute
      t.string :from
      t.string :to
      t.string :started_at
      t.string :ended_at
      t.bigint :elapsed_time
      t.bigint :elapsed_business_time

      t.timestamps null: false
    end
  end
end