# typed: strict

class Stories::CreateStory < Command
  extend T::Sig

  sig { params(story_prompt: String, drawing_style: String).void }
  def initialize(story_prompt, drawing_style)
    @story_prompt = story_prompt
    @drawing_style = drawing_style
    @story = T.let(Story.create!(title: "Story 1"), Story)
  end

  private

  sig { void }
  def execute
    begin
      Stories::CreateStoryCharacters.new(@story_prompt, @story).run
      Stories::CreateStoryCharactersImages.new(@story, @drawing_style).run
      Stories::CreateStoryChaptersWithImagesDescriptions.new(@story_prompt, @story).run
      Stories::CreateStoryChapterImages.new(@story, @drawing_style).run
    rescue => e
      Rails.logger.error("Story creation failed: #{e.message}")
      @story.failed!
      raise e
    end

    @story.created!
  end
end
