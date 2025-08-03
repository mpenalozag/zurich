# typed: strict

class OpenAiService
  API_BASE_URL = "https://api.openai.com/v1"
  IMAGE_GENERATION_MODEL = "gpt-image-1"
  TEXT_GENERATION_MODEL = "gpt-4.1-nano"
  IMAGE_GENERATION_URL = T.let("#{API_BASE_URL}/images/generations", String)
  IMAGE_EDITING_URL = T.let("#{API_BASE_URL}/images/edits", String)

  class << self
    extend T::Sig

    sig { returns(OpenAI::Client) }
    def client
      @client ||= T.let(OpenAI::Client.new(access_token: ENV.fetch("OPENAI_ACCESS_TOKEN")), T.nilable(OpenAI::Client))
    end

    sig { params(prompt: String).returns(String) }
    def get_characters_from_prompt(prompt)
      response = self.client.chat(
        parameters: {
          model: TEXT_GENERATION_MODEL,
          messages: [
            Stories::Prompts::GET_CHARACTERS_FROM_PROMPT_SYSTEM_ROLE,
            { role: "user", content: prompt }
          ],
          temperature: 0.7
        }
      )
      response.dig("choices", 0, "message", "content")
    end

    sig { params(prompt: String, characters: T::Hash[T.untyped, T.untyped]).returns(String) }
    def get_story_splitted_by_chapters_and_images(prompt, characters)
      response = self.client.chat(
        parameters: {
          model: TEXT_GENERATION_MODEL,
          messages: [
            Stories::Prompts::GET_STORY_IN_CHAPTERS_WITH_1_IMAGE_PER_CHAPTER_SYSTEM_ROLE,
            { role: "user", content: prompt },
            { role: "user", content: characters.to_json }
          ],
          temperature: 0.7
        }
      )
      response.dig("choices", 0, "message", "content")
    end

    sig { params(character_description: String, drawing_style: String).returns(String) }
    def get_character_image_from_description(character_description, drawing_style)
      style_string = "\nThe image should be a #{drawing_style} style"
      prompt = Stories::Prompts::GET_CHARACTER_IMAGE_FROM_DESCRIPTION_ROLE + character_description + style_string

      response = HTTParty.post(IMAGE_GENERATION_URL,
        timeout: 120,
        headers: request_headers,
        body: {
          model: IMAGE_GENERATION_MODEL,
          prompt: prompt,
          n: 1,
          output_format: "jpeg",
          quality: "low",
          size: "1024x1024"
        }.to_json
      )
      response.dig("data", 0, "b64_json")
    end

    sig { params(image_description: String, characters: T::Array[String], drawing_style: String).returns(String) }
    def get_chapter_image_based_on_description(image_description, characters, drawing_style)
      style_string = "\nThe image should be a #{drawing_style} style"
      characters_string = characters.join(", ")
      characters_text = "\nThe image must contain the following characters: #{characters_string}"
      prompt = Stories::Prompts::GET_IMAGE_FROM_DESCRIPTION_ROLE + image_description + style_string + characters_text

      response = HTTParty.post(IMAGE_EDITING_URL,
        timeout: 120,
        headers: request_headers,
        body: {
          model: IMAGE_GENERATION_MODEL,
          prompt: prompt,
          n: 1,
          output_format: "jpeg",
          quality: "low",
          size: "1024x1024"
        }.to_json
      )
      response.dig("data", 0, "b64_json")
    end

    private

    sig { returns(T::Hash[String, String]) }
    def request_headers
      {
        "Authorization" => "Bearer #{ENV.fetch("OPENAI_ACCESS_TOKEN")}",
        "Content-Type" => "application/json"
      }
    end
  end
end
