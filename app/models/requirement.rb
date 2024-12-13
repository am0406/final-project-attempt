# == Schema Information
#
# Table name: requirements
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_requirements_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Requirement < ApplicationRecord
  belongs_to :user
  has_many :meals, dependent: :destroy

  validates :description, presence: true
  validates :name, presence: true
end
