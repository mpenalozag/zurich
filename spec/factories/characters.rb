# == Schema Information
#
# Table name: characters
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  image_path  :string
#  story_id    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_characters_on_story_id  (story_id)
#

FactoryBot.define do
  factory :character do
    name { "MyString" }
    description { "MyText" }
    image_path { "MyString" }
    story { nil }
  end
end
