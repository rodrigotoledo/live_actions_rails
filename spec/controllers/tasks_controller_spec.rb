# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:valid_attributes) {
    {
      title: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph,
      scheduled_at: Faker::Time.forward(days: 30),
      completed: false
    }
  }

  let(:invalid_attributes) {
    { title: '', description: '' }
  }

  describe "GET #index" do
    it "returns a success response" do
      create_list(:task, 3)
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      task = create(:task)
      get :show, params: { id: task.to_param }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      task = create(:task)
      get :edit, params: { id: task.to_param }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Task" do
        expect {
          post :create, params: { task: valid_attributes }
        }.to change(Task, :count).by(1)
      end

      it "redirects to the created task" do
        post :create, params: { task: valid_attributes }
        expect(response).to redirect_to(task_url(Task.last))
      end
    end

    context "with invalid params" do
      it "returns unprocessable entity" do
        post :create, params: { task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT #update" do
    let(:task) { create(:task) }

    context "with valid params" do
      let(:new_attributes) {
        { title: Faker::Lorem.sentence, completed: true }
      }

      it "updates the requested task" do
        put :update, params: { id: task.to_param, task: new_attributes }
        task.reload
        expect(task.title).to eq(new_attributes[:title])
        expect(task.completed).to be true
      end

      it "redirects to the task" do
        put :update, params: { id: task.to_param, task: new_attributes }
        expect(response).to redirect_to(task_url(task))
      end
    end

    context "with invalid params" do
      it "returns unprocessable entity" do
        put :update, params: { id: task.to_param, task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested task" do
      task = create(:task)
      expect {
        delete :destroy, params: { id: task.to_param }
      }.to change(Task, :count).by(-1)
    end

    it "redirects to the tasks list" do
      task = create(:task)
      delete :destroy, params: { id: task.to_param }
      expect(response).to redirect_to(tasks_url)
    end
  end

  describe "GET #search" do
    let!(:matching_task) { create(:task, title: "Important meeting") }
    let!(:non_matching_task) { create(:task, title: "Regular work") }

    context "with search term" do
      it "returns matching tasks via turbo stream" do
        get :search, params: { search: "meeting" }, format: :turbo_stream
        expect(assigns(:tasks)).to include(matching_task)
        expect(assigns(:tasks)).not_to include(non_matching_task)
        expect(response).to render_template(layout: false)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context "without search term" do
      it "returns all tasks" do
        get :search, format: :turbo_stream
        expect(assigns(:tasks)).to include(matching_task, non_matching_task)
      end
    end
  end
end
