# typed: strict

class Stories::GetCharactersWithImages < Command
  extend T::Sig

  sig { params(characters: T::Hash[String, T.untyped], drawing_style: String).void }
  def initialize(characters, drawing_style)
    @characters = T.let(characters["characters"], T::Array[T::Hash[String, String]])
    @drawing_style = drawing_style
  end

  private

  sig { returns(T::Array[T::Hash[T.untyped, T.untyped]]) }
  def execute
    @characters.map do |character|
      character_description = T.must(character["description"])
      b64_image = OpenAiService.get_image_from_description(character_description, @drawing_style)
      image_path = Storage::StoreImage.new(image_data: b64_image, path: "characters/", data_type: "base64").run
      character["image_path"] = image_path
      character
    end
    @characters
  end
end
