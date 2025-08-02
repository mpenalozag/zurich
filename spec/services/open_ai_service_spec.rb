# typed: false

require 'rails_helper'

RSpec.describe OpenAiService do
  before do
    stub_const("ENV", { "OPENAI_ACCESS_TOKEN" => "test_token" })
  end

  describe '#client' do
    before do
      OpenAiService.instance_variable_set(:@client, nil)
    end

    it 'creates a new OpenAI client with the correct token' do
      expect(OpenAI::Client).to receive(:new).with(access_token: "test_token").and_call_original
      expect { OpenAiService.client }.not_to raise_error
    end

    it 'memoizes the client instance' do
      client1 = OpenAiService.client
      client2 = OpenAiService.client
      expect(client1).to be(client2)
    end
  end

  describe '#get_characters_from_prompt' do
    let(:prompt) { "Story of two brothers, John and Jack." }
    let(:expected_response) { "John: A brave knight\nJack: A wise wizard" }
    let(:mock_client) { instance_double(OpenAI::Client) }
    let(:mock_response) do
      {
        "choices" => [
          {
            "message" => {
              "content" => expected_response
            }
          }
        ]
      }
    end

    before do
      allow(OpenAiService).to receive(:client).and_return(mock_client)
      allow(mock_client).to receive(:chat).and_return(mock_response)
    end

    it 'calls the OpenAI client with correct parameters' do
      OpenAiService.get_characters_from_prompt(prompt)

      expect(mock_client).to have_received(:chat).with(
        parameters: {
          model: "gpt-4.1-nano",
          messages: [
            Stories::Prompts::GET_CHARACTERS_FROM_PROMPT_SYSTEM_ROLE,
            { role: "user", content: prompt }
          ],
          temperature: 0.7
        }
      )
    end

    it 'returns the characters from the API response' do
      result = OpenAiService.get_characters_from_prompt(prompt)
      expect(result).to eq(expected_response)
    end

    it 'extracts content from the response correctly' do
      result = OpenAiService.get_characters_from_prompt(prompt)
      expect(result).to eq("John: A brave knight\nJack: A wise wizard")
    end
  end

  describe '#get_story_splitted_by_chapters_and_images' do
    let(:prompt) { "Write a story about two brothers on an adventure." }
    let(:characters) { { "John" => "A brave knight", "Jack" => "A wise wizard" } }
    let(:expected_response) { "Chapter 1: The Beginning\n[Image: Two brothers setting out]" }
    let(:mock_client) { instance_double(OpenAI::Client) }
    let(:mock_response) do
      {
        "choices" => [
          {
            "message" => {
              "content" => expected_response
            }
          }
        ]
      }
    end

    before do
      allow(OpenAiService).to receive(:client).and_return(mock_client)
      allow(mock_client).to receive(:chat).and_return(mock_response)
    end

    it 'calls the OpenAI client with correct parameters' do
      OpenAiService.get_story_splitted_by_chapters_and_images(prompt, characters)

      expect(mock_client).to have_received(:chat).with(
        parameters: {
          model: "gpt-4.1-nano",
          messages: [
            Stories::Prompts::GET_STORY_IN_CHAPTERS_WITH_1_IMAGE_PER_CHAPTER_SYSTEM_ROLE,
            { role: "user", content: prompt },
            { role: "user", content: characters.to_json }
          ],
          temperature: 0.7
        }
      )
    end

    it 'returns the story content from the API response' do
      result = OpenAiService.get_story_splitted_by_chapters_and_images(prompt, characters)
      expect(result).to eq(expected_response)
    end

    it 'converts characters hash to JSON in the request' do
      OpenAiService.get_story_splitted_by_chapters_and_images(prompt, characters)

      expect(mock_client).to have_received(:chat) do |args|
        messages = args[:parameters][:messages]
        characters_message = messages.find { |msg| msg[:content].include?("John") }
        expect(characters_message[:content]).to eq(characters.to_json)
      end
    end
  end
end
