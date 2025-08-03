# typed: false

require "rails_helper"

RSpec.describe Stories::CreateStoryChaptersWithImagesDescriptions do
  let(:story_prompt) { "A story about a big cat and his friend the mouse" }
  let_it_be(:story) { create(:story, title: "Some story") }
  let_it_be(:first_character) { create(:character, name: "big cat", description: "A big cat", story: story) }
  let_it_be(:second_character) { create(:character, name: "mouse", description: "A mouse", story: story) }
  let(:command) { described_class.new(story_prompt, story) }
  let(:mock_openai_service) { double("OpenAiService") }

  before do
    stub_const("OpenAiService", mock_openai_service)
    allow(Rails).to receive(:env).and_return("development")
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
              "images": [
                {
                  "image_description": "A big cat and his friend the mouse",
                  "characters": [ "big cat", "mouse" ]
                }
              ]
            },
            {
              "chapter": "Chapter 2",
              "images": [
                {
                  "image_description": "A big cat and his friend the mouse dancing in the park",
                  "characters": [ "big cat", "mouse" ]
                }
              ]
            }
          ]
        }'
      )
      allow(Storage::StoreText).to receive(:new).and_return(double("Storage::StoreText", run: "path/to/text"))
    end

    let(:formatted_characters) do
      {
        "characters": [
          { "name": "big cat", "description": "A big cat" },
          { "name": "mouse", "description": "A mouse" }
        ]
      }
    end

    it 'calls the OpenAiService method to get the story splitted by chapters and images' do
      perform
      expect(mock_openai_service).to have_received(:get_story_splitted_by_chapters_and_images).with(story_prompt, formatted_characters)
    end

    it 'creates the story chapters with images descriptions' do
      perform
      expect(story.chapters.count).to eq(2)
      expect(story.chapters.first.text_path).to eq("path/to/text")
      expect(story.chapters.first.image_description).to eq("A big cat and his friend the mouse")
      expect(story.chapters.first.order).to eq(1)
      expect(story.chapters.first.image_characters).to eq([ "big cat", "mouse" ])
      expect(story.chapters.second.text_path).to eq("path/to/text")
      expect(story.chapters.second.image_description).to eq("A big cat and his friend the mouse dancing in the park")
      expect(story.chapters.second.order).to eq(2)
      expect(story.chapters.second.image_characters).to eq([ "big cat", "mouse" ])
    end

    it 'associates the story chapters to the story' do
      perform
      expect(story.chapters.first.story).to eq(story)
      expect(story.chapters.second.story).to eq(story)
    end
  end
end
