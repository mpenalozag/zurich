# typed: false

# == Schema Information
#
# Table name: characters
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  image_path  :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  story_id    :integer          not null
#
# Indexes
#
#  index_characters_on_story_id  (story_id)
#
# Foreign Keys
#
#  fk_rails_...  (story_id => stories.id)
#

require 'rails_helper'

RSpec.describe Character, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:story) }
  end

  describe "attributes" do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:image_path).of_type(:string) }
    it { is_expected.to have_db_column(:story_id).of_type(:integer) }
  end

  describe "foreign_keys" do
    let(:story) { create(:story) }
    let(:character) { create(:character, story: story) }

    it "returns associated story" do
      expect(character.story).to eq(story)
    end
  end
end
