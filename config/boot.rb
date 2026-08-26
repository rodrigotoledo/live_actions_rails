# frozen_string_literal: true

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.

# SimpleCov enables coverage before Rails boots in specs; Bootsnap's ISeq cache
# cannot compile bytecode while coverage is active (Ruby 4+).
require "bootsnap/setup" unless ENV["RAILS_ENV"] == "test"
