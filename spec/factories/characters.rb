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

FactoryBot.define do
  factory :character do
    name { "MyString" }
    description { "MyText" }
    image_path { "MyString" }
    story { nil }
  end
end
