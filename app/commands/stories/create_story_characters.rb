# typed: strict

class Stories::CreateStoryCharacters < Command
  extend T::Sig

  sig { params(story_prompt: String, story: Story).void }
  def initialize(story_prompt, story)
    @story_prompt = story_prompt
    @story = story
  end

  private

  sig { void }
  def execute
    Rails.logger.info("Getting characters from prompt and associating them to story")
    response = OpenAiService.get_characters_from_prompt(@story_prompt)
    characters = JSON.parse(response)["characters"]
    create_story_characters(characters)
  end

  sig { params(characters: T::Array[T::Hash[String, String]]).void }
  def create_story_characters(characters)
    characters.each do |character|
      Character.create!(name: character["name"], description: character["description"], story: @story)
    end
  end
end
