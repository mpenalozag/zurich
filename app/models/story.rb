# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :string
#

class Story < ApplicationRecord
  enum :status, {
    created: "created",
    creating: "creating",
    failed: "failed"
  }

  has_many :characters, dependent: :destroy
  has_many :chapters, dependent: :destroy
end
