# == Schema Information
#
# Table name: chapters
#
#  id                :integer          not null, primary key
#  text_path         :string
#  image_path        :string
#  story_id          :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  image_description :text             not null
#  order             :integer          not null
#
# Indexes
#
#  index_chapters_on_story_id  (story_id)
#

class Chapter < ApplicationRecord
  belongs_to :story
end
