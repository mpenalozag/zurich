# typed: false

require 'rails_helper'

RSpec.describe Story do
  let(:story) { create(:story, title: "Some Title") }

  it "has a title" do
    expect(story.title).to eq("Some Title")
  end
end
