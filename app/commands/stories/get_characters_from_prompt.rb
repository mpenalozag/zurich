# typed: strict

class Stories::GetCharactersFromPrompt < Command
  extend T::Sig

  sig { params(story_prompt: String).void }
  def initialize(story_prompt)
    @story_prompt = story_prompt
  end
  
  private

  sig { returns(T::Hash[T.untyped, T.untyped]) }
  def execute
    response = OpenAiService.get_characters_from_prompt(@story_prompt)
    JSON.parse(response)
  end
end
