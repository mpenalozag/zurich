# typed: false

require "rails_helper"

RSpec.describe Stories::GetStorySplittedByChaptersWithImages do
  let(:story_prompt) { "A story about a big cat and his friend the mouse" }
  let(:characters) { { "characters" => [{ "name" => "big cat", "description" => "A big cat" }, { "name" => "mouse", "description" => "A mouse" }] } }
  let(:command) { described_class.new(story_prompt, characters) }
  let(:mock_openai_service) { double("OpenAiService") }

  before do
    stub_const("OpenAiService", mock_openai_service)
  end

  def perform
    command.run
  end

  describe '#execute' do
    before do
      allow(mock_openai_service).to receive(:get_story_splitted_by_chapters_and_images).and_return(
        '{ 
          "chapters": [
            { 
              "chapter": "Chapter 1", 
              "image": "A big cat and his friend the mouse"
            },
            { 
              "chapter": "Chapter 2", 
              "image": "A big cat and his friend the mouse dancing in the park"
            }
          ] 
        }'
      )
    end

    it 'calls the OpenAiService method to get the story splitted by chapters and images' do
      perform
      expect(mock_openai_service).to have_received(:get_story_splitted_by_chapters_and_images).with(story_prompt, characters)
    end

    it 'returns the story splitted by chapters and images' do
      expect(perform).to eq(
        { 
          "chapters" => [
            { 
              "chapter" => "Chapter 1", 
              "image" => "A big cat and his friend the mouse" 
            }, 
            { 
              "chapter" => "Chapter 2", 
              "image" => "A big cat and his friend the mouse dancing in the park" 
            }
          ] 
        }
      )
    end
  end
end
