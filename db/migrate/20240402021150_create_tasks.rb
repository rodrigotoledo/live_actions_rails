# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.datetime :scheduled_at
      t.boolean :completed

      t.timestamps
    end
  end
end
