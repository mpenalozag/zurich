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

FactoryBot.define do
  factory :chapter do
    text_path { "MyString" }
    image_path { "MyString" }
    story { nil }
  end
end
