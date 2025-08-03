# typed: false

require 'rails_helper'

RSpec.describe Stories::CreateStoryCharactersImages do
  let!(:story) { create(:story, title: "Some story") }
  let!(:first_character) { create(:character, name: "John", description: "A man with a beard", story: story, image_path: nil) }
  let!(:second_character) { create(:character, name: "Jane", description: "A woman with no beard", story: story, image_path: nil) }

  let(:drawing_style) { "cartoon" }

  let(:command) { described_class.new(story, drawing_style) }
  let(:storage_service) { instance_double(Storage::StoreImage) }

  before do
    stub_const("ENV", { "OPENAI_ACCESS_TOKEN" => "test_key" })
  end

  describe "#execute" do
    def perform
      command.run
    end

    before do
      allow(OpenAiService).to receive(:get_character_image_from_description).and_return("b64_image")
      allow(Storage::StoreImage).to receive(:new).and_return(storage_service)
      allow(storage_service).to receive(:run).and_return("image_path")
    end

    context 'when calling the open AI service to generate images' do
      it 'uses the correct parameters' do
        perform
        expect(OpenAiService).to have_received(:get_character_image_from_description).with(first_character.description, drawing_style)
        expect(OpenAiService).to have_received(:get_character_image_from_description).with(second_character.description, drawing_style)
      end
    end

    context 'when calling the storage service to store the images' do
      it 'stores the images in the storage' do
        perform
        expect(storage_service).to have_received(:run).twice
      end
    end

    context 'when setting the image path for each character' do
      it 'sets the image path for each character' do
        expect(first_character.image_path).to be_nil
        expect(second_character.image_path).to be_nil
        perform
        expect(first_character.reload.image_path).to eq("image_path")
        expect(second_character.reload.image_path).to eq("image_path")
      end
    end
  end
end
