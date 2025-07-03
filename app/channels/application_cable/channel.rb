# frozen_string_literal: true

module ApplicationCable
  class Channel < ActionCable::Channel::Base
    include CableReady::Broadcaster
  end
end
