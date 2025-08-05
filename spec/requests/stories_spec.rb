# typed: false

require "rails_helper"

RSpec.describe "Stories API", type: :request do
  describe "POST #create_story" do
    def perform(headers: {}, params: { "story_prompt" => "A story about a cat", "drawing_style" => "cartoon" })
      post '/stories/create_story', params: params, headers: headers
    end

    context 'when request is not valid' do
      context 'when story_prompt is not present' do
        it 'returns a unprocessable entity response' do
          perform(params: { drawing_style: "cartoon" })
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq({ errors: { story_prompt: [ "is missing" ] } }.to_json)
        end
      end

      context 'when drawing_style is not present' do
        it 'returns a unprocessable entity response' do
          perform(params: { story_prompt: "A story about a cat" })
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq({ errors: { drawing_style: [ "is missing" ] } }.to_json)
        end
      end
    end

    context 'when request is valid' do
      it 'returns a accepted response' do
        perform(params: { story_prompt: "A story about a cat", drawing_style: "cartoon" })
        expect(response).to have_http_status(:accepted)
        expect(response.body).to eq({ message: "Story creation started" }.to_json)
      end
    end
  end

  describe "GET #get_stories" do
    def perform(headers: {}, params: {})
      get '/stories/get_stories', params: params, headers: headers
    end

    context 'when there are no stories' do
      it 'returns a ok response' do
        perform
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ stories: [] }.to_json)
      end
    end

    context 'when there are stories' do
      let!(:story1) { create(:story, title: "Story 1") }
      let!(:story2) { create(:story, title: "Story 2") }

      it 'returns a ok response' do
        perform
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(story1.to_json)
        expect(response.body).to include(story2.to_json)
      end
    end
  end

  describe "GET #get_story" do
    def perform(headers: {}, params: {})
      get '/stories/get_story', params: params, headers: headers
    end

    describe 'when request is not valid' do
      context 'when id is not present' do
        it 'returns a unprocessable entity response' do
          perform
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq({ errors: { id: [ "is missing" ] } }.to_json)
        end
      end
    end

    describe 'when request is valid' do
      context 'when story is not found' do
        it 'returns a not found response' do
          perform(params: { id: 1 })
          expect(response).to have_http_status(:not_found)
          expect(response.body).to eq({ error: "Story not found" }.to_json)
        end
      end

      context 'when story is found' do
        let(:story) { create(:story, title: "Story 1") }

        it 'returns a ok response' do
          perform(params: { id: story.id })
          expect(response).to have_http_status(:ok)
          expect(response.body).to include(story.to_json)
        end
      end
    end
  end
end
