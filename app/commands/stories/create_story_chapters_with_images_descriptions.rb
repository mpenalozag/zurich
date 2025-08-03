# typed: strict

class Stories::CreateStoryChaptersWithImagesDescriptions < Command
  extend T::Sig

  sig { params(story_prompt: String, story: Story).void }
  def initialize(story_prompt, story)
    @story_prompt = story_prompt
    @story = story
  end

  private

  sig { void }
  def execute
    Rails.logger.info("Creating story chapters with images descriptions")
    response = OpenAiService.get_story_splitted_by_chapters_and_images(@story_prompt, formatted_characters)
    chapters = JSON.parse(response)["chapters"]
    create_story_chapters(chapters)
  end

  sig { returns(T::Hash[Symbol, T::Array[T::Hash[Symbol, String]]]) }
  def formatted_characters
    {
      "characters":
        @story.characters.map do |character|
          { "name": character.name, "description": character.description }
        end
    }
  end

  sig { params(chapters: T::Array[T::Hash[String, String]]).void }
  def create_story_chapters(chapters)
    chapters.each_with_index do |chapter, index|
      chapter_text = T.must(chapter["chapter"])
      image_description = T.must(chapter["image_description"])
      text_path = Storage::StoreText.new(text: chapter_text).run
      Chapter.create!(order: index + 1, text_path: text_path, image_description: image_description, story: @story)
    end
  end
end
