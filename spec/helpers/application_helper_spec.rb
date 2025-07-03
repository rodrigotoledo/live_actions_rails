# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#flash_message' do
    context 'when message is blank' do
      it 'returns nil' do
        expect(helper.flash_message(nil)).to be_nil
        expect(helper.flash_message('')).to be_nil
      end
    end

    context 'when message is present' do
      let(:message) { 'Test message' }

      it 'returns a paragraph tag with the message' do
        result = helper.flash_message(message)
        expect(result).to have_selector('p', text: message)
      end

      it 'includes base classes' do
        result = helper.flash_message(message)
        expect(result).to have_selector('p.py-2.px-3.mb-5.font-medium.rounded-lg.inline-block')
      end

      context 'with notice type' do
        it 'includes notice styling classes' do
          result = helper.flash_message(message, type: :notice)
          expect(result).to have_selector('p.bg-green-900\\/30.text-green-400')
          expect(result).to have_selector('p#flash_notice')
        end
      end

      context 'with alert type' do
        it 'includes alert styling classes' do
          result = helper.flash_message(message, type: :alert)
          expect(result).to have_selector('p.bg-red-900\\/30.text-red-400')
          expect(result).to have_selector('p#flash_alert')
        end
      end

      context 'with custom type' do
        it 'includes default styling classes' do
          result = helper.flash_message(message, type: :custom)
          expect(result).to have_selector('p.bg-gray-800.text-gray-300')
          expect(result).to have_selector('p#flash_custom')
        end
      end

      context 'without specified type' do
        it 'defaults to notice styling' do
          result = helper.flash_message(message)
          expect(result).to have_selector('p.bg-green-900\\/30.text-green-400')
        end
      end
    end
  end
end
