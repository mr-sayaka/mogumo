class Post < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  validates :title, presence: true
  validates :introduction, presence: true
  validates :ingredients, presence: true
  validates :how_to_make, presence: true
  validates :target_age, presence: true
end