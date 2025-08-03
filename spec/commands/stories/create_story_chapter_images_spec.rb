# typed: false

require "rails_helper"

RSpec.describe Stories::CreateStoryChapterImages do
  let(:story) { create(:story) }
  let(:first_character_in_image) { create(:character, name: "big cat", description: "A big cat", story: story) }
  let(:second_character_in_image) { create(:character, name: "mouse", description: "A mouse", story: story) }

  let(:command) { described_class.new(story, "cartoon") }
  let(:store_image) { double("Storage::StoreImage") }

  describe "#execute" do
    context "when no characters are in the image" do
      let!(:first_chapter) { create(:chapter, story: story, image_characters: [], image_path: nil) }

      before do
        allow(Rails).to receive(:env).and_return("development")
        allow(OpenAiService).to receive(:get_chapter_image_based_on_description).and_return("base64_image")
        allow(Storage::StoreImage).to receive(:new).and_return(store_image)
        allow(store_image).to receive(:run).and_return("image_path")
      end

      it "calls openai service with no characters params and the correct amount of times" do
        command.run

        expect(OpenAiService).to have_received(:get_chapter_image_based_on_description)
        .with(
          first_chapter.image_description,
          [],
          [],
          "cartoon"
        )
      end

      it "calls the storage service with the correct path" do
        command.run

        expect(Storage::StoreImage).to have_received(:new)
        .with(image_data: "base64_image", path: "chapters/images/", data_type: "base64")
        expect(store_image).to have_received(:run)
      end

      it "updates the chapter with the correct image path" do
        expect(first_chapter.image_path).to eq(nil)
        command.run
        first_chapter.reload
        expect(first_chapter.image_path).to eq("image_path")
      end
    end

    context "when there are characters in the image" do
      let!(:chapter_with_characters) { create(:chapter, story: story, image_characters: [ first_character_in_image.name, second_character_in_image.name ], image_path: nil) }

      before do
        allow(Rails).to receive(:env).and_return("development")
        allow(OpenAiService).to receive(:get_chapter_image_based_on_description).and_return("base64_image")
        allow(Storage::StoreImage).to receive(:new).and_return(store_image)
        allow(store_image).to receive(:run).and_return("image_path")
      end

      it "calls openai service with the correct characters params" do
        command.run

        expect(OpenAiService).to have_received(:get_chapter_image_based_on_description)
          .with(
            chapter_with_characters.image_description,
            [ first_character_in_image.image_path, second_character_in_image.image_path ],
            [ first_character_in_image.name, second_character_in_image.name ],
            "cartoon"
          )
      end

      it "calls the storage service with the correct path" do
        command.run

        expect(Storage::StoreImage).to have_received(:new)
        .with(image_data: "base64_image", path: "chapters/images/", data_type: "base64")
        expect(store_image).to have_received(:run)
      end

      it "updates the chapter with the correct image path" do
        expect(chapter_with_characters.image_path).to eq(nil)
        command.run
        chapter_with_characters.reload
        expect(chapter_with_characters.image_path).to eq("image_path")
      end
    end
  end
end
