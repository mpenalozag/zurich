# typed: strict

class OpenAiService
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
          model: "gpt-4.1-nano",
          messages: [
            Stories::Prompts::GET_CHARACTERS_FROM_PROMPT_SYSTEM_ROLE,
            { role: "user", content: prompt }
          ],
          temperature: 0.7,
        }
      )
      response.dig("choices", 0, "message", "content")
    end

    sig { params(prompt: String, characters: T::Hash[T.untyped, T.untyped]).returns(String) }
    def get_story_splitted_by_chapters_and_images(prompt, characters)
      response = self.client.chat(
        parameters: {
          model: "gpt-4.1-nano",
          messages: [
            Stories::Prompts::GET_STORY_IN_CHAPTERS_WITH_1_IMAGE_PER_CHAPTER_SYSTEM_ROLE,
            { role: "user", content: prompt },
            { role: "user", content: characters.to_json }
          ],
          temperature: 0.7,
        }
      )
      response.dig("choices", 0, "message", "content")
    end
  end
end
