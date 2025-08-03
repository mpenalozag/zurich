# typed: false

require 'rails_helper'

RSpec.describe CreateStoryJob, type: :job do
  let(:job) { CreateStoryJob.new }
  let(:story_prompt) { "A story about a cat" }
  let(:drawing_style) { "A drawing style" }

  describe "#perform" do
    before do
      allow(Stories::CreateStory).to receive(:new).and_return(double(run: true))
    end

    it "calls create story command" do
      job.perform(story_prompt, drawing_style)
      expect(Stories::CreateStory).to have_received(:new).with(story_prompt, drawing_style)
    end
  end
end
