# typed: false

require "rails_helper"

RSpec.describe Stories::CreateStory do
  let(:story_prompt) { "A story about a cat and a dog" }
  let(:drawing_style) { "cartoon" }
  let(:command) { described_class.new(story_prompt, drawing_style) }

  def perform
    command.run
  end

  describe "#unit tests" do
    let(:create_story_characters_command) { double("Stories::CreateStoryCharacters") }
    let(:create_story_characters_images_command) { double("Stories::CreateStoryCharactersImages") }
    let(:create_story_chapters_with_images_descriptions_command) { double("Stories::CreateStoryChaptersWithImagesDescriptions") }
    let(:create_story_chapter_images_command) { double("Stories::CreateStoryChapterImages") }

    before do
      allow(Stories::CreateStoryCharacters).to receive(:new).and_return(create_story_characters_command)
      allow(Stories::CreateStoryCharactersImages).to receive(:new).and_return(create_story_characters_images_command)
      allow(Stories::CreateStoryChaptersWithImagesDescriptions).to receive(:new).and_return(create_story_chapters_with_images_descriptions_command)
      allow(Stories::CreateStoryChapterImages).to receive(:new).and_return(create_story_chapter_images_command)

      allow(create_story_characters_command).to receive(:run)
      allow(create_story_characters_images_command).to receive(:run)
      allow(create_story_chapters_with_images_descriptions_command).to receive(:run)
      allow(create_story_chapter_images_command).to receive(:run)
    end

    it 'calls the correct commands' do
      perform

      expect(create_story_characters_command).to have_received(:run)
      expect(create_story_characters_images_command).to have_received(:run)
      expect(create_story_chapters_with_images_descriptions_command).to have_received(:run)
      expect(create_story_chapter_images_command).to have_received(:run)
    end
  end

  describe "#integration tests" do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
