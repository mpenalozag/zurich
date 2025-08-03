# typed: false

require 'rails_helper'

RSpec.describe OpenAiService do
  before do
    stub_const("ENV", { "OPENAI_ACCESS_TOKEN" => "test_token" })
    stub_const("OpenAiService::API_BASE_URL", "https://api.openai.com/v1")
    stub_const("OpenAiService::IMAGE_GENERATION_MODEL", "gpt-image-1")
    stub_const("OpenAiService::TEXT_GENERATION_MODEL", "gpt-4.1-nano")
    stub_const("OpenAiService::IMAGE_GENERATION_URL", "https://api.openai.com/v1/images/generations")
  end

  describe '#constants' do
    it 'has the correct constants' do
      expect(OpenAiService::API_BASE_URL).to eq("https://api.openai.com/v1")
      expect(OpenAiService::IMAGE_GENERATION_MODEL).to eq("gpt-image-1")
      expect(OpenAiService::TEXT_GENERATION_MODEL).to eq("gpt-4.1-nano")
      expect(OpenAiService::IMAGE_GENERATION_URL).to eq("https://api.openai.com/v1/images/generations")
    end
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

  describe '#get_character_image_from_description' do
    let(:character_description) { "A brave knight with a sword" }
    let(:drawing_style) { "cartoon" }
    let(:expected_response) { "b64_image" }
    let(:mock_response) { { "data" => [ { "b64_json" => expected_response } ] } }
    let(:mock_client) { instance_double(OpenAI::Client) }

    before do
      allow(HTTParty).to receive(:post).and_return(mock_response)
      stub_const("OpenAiService::IMAGE_GENERATION_URL", "https://some-url.com")
      stub_const("Stories::Prompts::GET_CHARACTER_IMAGE_FROM_DESCRIPTION_ROLE", "Some prompt\n")
    end

    it 'calls the OpenAI client with correct parameters' do
      OpenAiService.get_character_image_from_description(character_description, drawing_style)

      expect(HTTParty).to have_received(:post).with(
        "https://some-url.com", {
          body: {
            model: "gpt-image-1",
            prompt: "Some prompt\nA brave knight with a sword\nThe image should be a #{drawing_style} style",
            n: 1,
            output_format: "jpeg",
            quality: "low",
            size: "1024x1024"
          }.to_json,
          timeout: 120,
          headers: {
            "Authorization" => "Bearer test_token",
            "Content-Type" => "application/json"
          }
        }
      )
    end
  end

  describe '#get_chapter_image_based_on_description' do
    let(:image_description) { "Johnny the cat and Jack the dog walking in the park" }
    let(:characters_images_path) { [ 'characters/johnny.jpg', 'characters/jack.jpg' ] }
    let(:characters) { [ 'Johnny', 'Jack' ] }
    let(:drawing_style) { "cartoon" }
    let(:expected_response) { "b64_image" }
    let(:mock_response) { { "data" => [ { "b64_json" => expected_response } ] } }
    let(:mock_client) { instance_double(OpenAI::Client) }

    before do
      allow(HTTParty).to receive(:post).and_return(mock_response)
      stub_const("OpenAiService::IMAGE_EDITING_URL", "https://some-url.com")
      stub_const("Stories::Prompts::GET_IMAGE_FROM_DESCRIPTION_ROLE", "Some prompt\n")
    end

    it 'calls the OpenAI client with correct parameters' do
      OpenAiService.get_chapter_image_based_on_description(image_description, characters_images_path, characters, drawing_style)

      expect(HTTParty).to have_received(:post).with(
        "https://some-url.com", {
          body: {
            model: "gpt-image-1",
            image: characters_images_path,
            prompt: "Some prompt\nJohnny the cat and Jack the dog walking in the park\nThe image should be a #{drawing_style} style\nThe image must contain the following characters: Johnny, Jack",
            n: 1,
            output_format: "jpeg",
            quality: "low",
            size: "1024x1024"
          }.to_json,
          timeout: 120,
          headers: {
            "Authorization" => "Bearer test_token",
            "Content-Type" => "application/json"
          }
        }
      )
    end

    it 'returns the image from the API response' do
      result = OpenAiService.get_chapter_image_based_on_description(image_description, characters_images_path, characters, drawing_style)
      expect(result).to eq(expected_response)
    end
  end
end
