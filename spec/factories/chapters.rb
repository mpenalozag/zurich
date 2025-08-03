# == Schema Information
#
# Table name: chapters
#
#  id                :bigint           not null, primary key
#  image_characters  :string           default([]), is an Array
#  image_description :text             not null
#  image_path        :string
#  order             :integer          not null
#  text_path         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  story_id          :bigint           not null
#
# Indexes
#
#  index_chapters_on_story_id  (story_id)
#
# Foreign Keys
#
#  fk_rails_...  (story_id => stories.id)
#

FactoryBot.define do
  factory :chapter do
    text_path { "MyString" }
    image_path { "MyString" }
    story { nil }
    image_description { "Some nice image description" }
    order { 1 }
  end
end
