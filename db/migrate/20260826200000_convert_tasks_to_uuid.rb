# frozen_string_literal: true

class ConvertTasksToUuid < ActiveRecord::Migration[8.0]
  def up
    return if connection.columns(:tasks).find { |c| c.name == "id" }&.sql_type == "uuid"

    add_column :tasks, :uuid, :uuid, default: -> { "gen_random_uuid()" }, null: false
    remove_column :tasks, :id
    rename_column :tasks, :uuid, :id
    execute "ALTER TABLE tasks ADD PRIMARY KEY (id)"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
