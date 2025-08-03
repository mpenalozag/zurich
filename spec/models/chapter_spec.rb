# typed: false

# == Schema Information
#
# Table name: chapters
#
#  id         :integer          not null, primary key
#  text_path  :string
#  image_path :string
#  story_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_chapters_on_story_id  (story_id)
#

require 'rails_helper'

RSpec.describe Chapter, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:story) }
  end

  describe "attributes" do
    it { is_expected.to have_db_column(:text_path).of_type(:string) }
    it { is_expected.to have_db_column(:image_path).of_type(:string) }
    it { is_expected.to have_db_column(:story_id).of_type(:integer) }
  end

  describe "foreign_keys" do
    let(:story) { create(:story) }
    let(:chapter) { create(:chapter, story: story) }

    it "returns associated story" do
      expect(chapter.story).to eq(story)
    end
  end
end
