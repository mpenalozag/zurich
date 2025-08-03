# typed: strict

class Stories::CreateStoryCharactersImages < Command
  extend T::Sig

  sig { params(story: Story, drawing_style: String).void }
  def initialize(story, drawing_style)
    @story = story
    @drawing_style = drawing_style
  end

  private

  sig { void }
  def execute
    Rails.logger.info("Creating images for story characters")
    characters = @story.characters
    characters.each do |character|
      character_description = character.description
      b64_image = OpenAiService.get_character_image_from_description(character_description, @drawing_style)
      image_path = Storage::StoreImage.new(image_data: b64_image, path: "characters/", data_type: "base64").run
      character.update!(image_path: image_path)
    end
    Rails.logger.info("Created images for characters")
  end
end
