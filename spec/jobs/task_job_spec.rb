# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskJob, type: :job do
  include ActiveJob::TestHelper

  let(:task) { create(:task, title: 'Old title', description: 'Old description') }

  describe '#perform' do
    it 'updates the task with fake data' do
      expect {
        described_class.perform_now(task)
      }.to change { task.reload.title }
       .and change { task.reload.description }
    end
  end

  describe 'queueing' do
    it 'is enqueued to the default queue' do
      expect {
        described_class.perform_later(task)
      }.to have_enqueued_job(described_class)
    end
  end
end
