# frozen_string_literal: true

class EnablePgvectorExtension < ActiveRecord::Migration[8.0]
  def change
    enable_extension "pgcrypto"
    enable_extension "vector"
  end
end
