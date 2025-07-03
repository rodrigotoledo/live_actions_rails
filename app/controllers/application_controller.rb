# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include CableReady::Broadcaster
end
