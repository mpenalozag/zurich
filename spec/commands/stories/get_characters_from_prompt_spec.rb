# typed: false

require "rails_helper"

RSpec.describe Stories::GetCharactersFromPrompt do
  let(:story_prompt) { "A story about a big cat and his friend the mouse" }
  let(:command) { described_class.new(story_prompt) }
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

    it 'returns the characters from the prompt' do
      expect(perform).to eq(
        {
          "characters" => [
            {
              "name" => "big cat",
              "description" => "A big cat"
            },
            {
              "name" => "mouse",
              "description" => "A mouse"
            }
          ]
        }
      )
    end
  end
end
