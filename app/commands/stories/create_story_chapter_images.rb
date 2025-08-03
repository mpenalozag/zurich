# typed: strict

class Stories::CreateStoryChapterImages < Command
  extend T::Sig

  sig { params(story: Story, drawing_style: String).void }
  def initialize(story, drawing_style)
    @story = story
    @drawing_style = drawing_style
  end

  private

  sig { void }
  def execute
    @story.chapters.each do |chapter|
      characters_images_paths = @story.characters.select { |character| T.must(chapter.image_characters).include?(character.name) }.map { |character| T.must(character.image_path) }
      b64_image = OpenAiService.get_chapter_image_based_on_description(chapter.image_description, characters_images_paths, T.must(chapter.image_characters), @drawing_style)
      image_path = Storage::StoreImage.new(image_data: b64_image, path: "chapters/images/", data_type: "base64").run
      chapter.update!(image_path:)
    end
  end
end
