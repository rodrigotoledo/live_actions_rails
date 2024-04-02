# frozen_string_literal: true

class TaskReflex < ApplicationReflex
  def search
    @tasks = Task.order(created_at: :desc)
    if params[:search].present?
      @tasks = @tasks.where('title LIKE :search OR description LIKE :search', search: "%#{params[:search]}%")
    end

    morph '#tasks', render(@tasks)
  end
end
