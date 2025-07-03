# frozen_string_literal: true

class ExamplesController < ApplicationController
  layout false

  def show
    respond_to(&:html)
  end
end
