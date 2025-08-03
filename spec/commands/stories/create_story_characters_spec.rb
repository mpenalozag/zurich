# typed: false

require "rails_helper"

RSpec.describe Stories::CreateStoryCharacters do
  let(:story_prompt) { "A story about a big cat and his friend the mouse" }
  let(:story) { create(:story, title: "Some story") }
  let(:command) { described_class.new(story_prompt, story) }
  let(:mock_openai_service) { double("OpenAiService") }

  before do
    stub_const("OpenAiService", mock_openai_service)
  end

  def perform
    command.run
  end

  describe '#execute' do
    before do
      allow(mock_openai_service).to receive(:get_characters_from_prompt).and_return(
        '{
          "characters": [
            { "name": "big cat", "description": "A big cat" },
            { "name": "mouse", "description": "A mouse" }
          ]
        }'
      )
    end

    it 'calls the OpenAiService method to get the characters from the prompt' do
      perform
      expect(mock_openai_service).to have_received(:get_characters_from_prompt).with(story_prompt)
    end

    it 'creates the characters from the prompt' do
      perform
      expect(story.characters.count).to eq(2)
      expect(story.characters.first.name).to eq("big cat")
      expect(story.characters.first.description).to eq("A big cat")
      expect(story.characters.second.name).to eq("mouse")
      expect(story.characters.second.description).to eq("A mouse")
    end
  end
end
