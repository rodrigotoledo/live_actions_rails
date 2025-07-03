# frozen_string_literal: true

module ApplicationHelper
  def flash_message(message, type: :notice)
    return unless message.present?

    base_classes = "py-2 px-3 mb-5 font-medium rounded-lg inline-block"
    type_classes = case type.to_sym
    when :notice then "bg-green-900/30 text-green-400"
    when :alert then "bg-red-900/30 text-red-400"
    else "bg-gray-800 text-gray-300"
    end

    content_tag(:p, message, id: "flash_#{type}", class: "#{base_classes} #{type_classes}")
  end
end
