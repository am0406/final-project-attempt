# == Schema Information
#
# Table name: meals
#
#  id             :bigint           not null, primary key
#  ingredients    :text
#  instructions   :text
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  requirement_id :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_meals_on_requirement_id  (requirement_id)
#  index_meals_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (requirement_id => requirements.id)
#  fk_rails_...  (user_id => users.id)
#

class Meal < ApplicationRecord
  belongs_to :user
  belongs_to :requirement
end

class User < ApplicationRecord
  
  has_many :meals
end

class Requirement < ApplicationRecord
  belongs_to :user
  has_many :meals, dependent: :destroy
end
