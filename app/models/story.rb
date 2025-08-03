# == Schema Information
#
# Table name: stories
#
#  id         :bigint           not null, primary key
#  status     :string           default("creating")
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
