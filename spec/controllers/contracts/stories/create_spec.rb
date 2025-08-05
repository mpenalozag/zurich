# typed: false

require "rails_helper"

RSpec.describe Contracts::Stories::Create do
  let(:contract) { described_class.new }
  let(:params) { { story_prompt:, drawing_style: } }
  let(:story_prompt) { "A story about a cat" }
  let(:drawing_style) { "cartoon" }

  describe "contract" do
    describe "when params are valid" do
      it "returns a success response" do
        result = contract.call(params)
        expect(result).to be_success
      end
    end

    describe "when params are invalid" do
      context 'when story_prompt is not present' do
        it "returns a failure response" do
          result = contract.call(params.except(:story_prompt))
          expect(result).to be_failure
        end
      end

      context 'when drawing_style is not present' do
        it "returns a failure response" do
          result = contract.call(params.except(:drawing_style))
          expect(result).to be_failure
        end
      end
    end

    describe "when there are extra params" do
      it "returns a success response" do
        result = contract.call(params.merge(extra: "extra"))
        expect(result).to be_success
      end
    end
  end
end
