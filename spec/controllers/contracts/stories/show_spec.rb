# typed: false

require "rails_helper"

RSpec.describe Contracts::Stories::Show do
  let(:contract) { described_class.new }
  let(:params) { { id: 1 } }

  describe "contract" do
    describe "when params are valid" do
      it "returns a success response" do
        result = contract.call(params)
        expect(result).to be_success
      end
    end

    describe "when params are invalid" do
      context 'when id is not present' do
        it "returns a failure response" do
          result = contract.call(params.except(:id))
          expect(result).to be_failure
        end
      end
    end
  end
end
