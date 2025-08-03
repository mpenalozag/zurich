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

FactoryBot.define do
  factory :story do
    title { "My Story" }
  end
end
