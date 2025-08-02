# typed: strict

class Stories::GetStorySplittedByChaptersWithImages < Command
  extend T::Sig

  sig { params(story_prompt: String, characters: T::Hash[T.untyped, T.untyped]).void }
  def initialize(story_prompt, characters)
    @story_prompt = story_prompt
    @characters = characters
  end

  private

  sig { returns(T::Hash[T.untyped, T.untyped]) }
  def execute
    response = OpenAiService.get_story_splitted_by_chapters_and_images(@story_prompt, @characters)
    JSON.parse(response)
  end
end
