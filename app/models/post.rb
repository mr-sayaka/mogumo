class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true

  has_one_attached :image

  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :introduction, presence: true
  validates :ingredients, presence: true
  validates :how_to_make, presence: true
  validates :target_age, presence: true
end