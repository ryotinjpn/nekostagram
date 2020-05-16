class Comment < ApplicationRecord
  belongs_to :micropost
  validates :body, presence: true
end
