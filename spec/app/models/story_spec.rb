# typed: false

RSpec.describe Story do
  let(:story) { create(:story) }

  it "has a title" do
    expect(story.title).to eq("My Story")
  end
end