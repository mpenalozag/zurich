require 'rails_helper'

RSpec.describe CreateStoryJob, type: :job do
  let(:job) { CreateStoryJob.new }
  let(:prompt) { "A story about a cat" }

  describe "#perform" do
    before do
      allow(Stories::CreateStory).to receive(:new).and_return(double(run: true))
    end

    it "calls create story command" do
      job.perform(prompt)
      expect(Stories::CreateStory).to have_received(:new).with(prompt)
    end
  end
end
