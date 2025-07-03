# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { build(:task) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(task).to be_valid
    end

    it "is not valid without a title" do
      task.title = nil
      expect(task).not_to be_valid
      expect(task.errors[:title]).not_to be_blank
    end
  end

  describe "callbacks" do
    describe "after_create_commit" do
      it "broadcasts prepend to tasks stream" do
        expect {
          task.save
        }.to have_broadcasted_to("tasks")
      end
    end

    describe "after_update_commit" do
      let!(:saved_task) { create(:task) }

      it "broadcasts replace to tasks stream" do
        expect {
          saved_task.update(title: "Updated title")
        }.to have_broadcasted_to("tasks")
      end
    end

    describe "after_destroy" do
      let!(:saved_task) { create(:task) }

      it "broadcasts remove to tasks stream" do
        expect {
          saved_task.destroy
        }.to have_broadcasted_to("tasks")
      end
    end
  end
end
