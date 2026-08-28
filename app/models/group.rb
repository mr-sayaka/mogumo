class Group < ApplicationRecord
  belongs_to :admin

  has_many :group_memberships, dependent: :destroy

  has_many :members,
           through: :group_memberships,
           source: :user
  has_many :posts

  validates :name, presence: true
  validates :name, length: { maximum: 100 }
  validates :description, length: { maximum: 500 }, allow_blank: true
  validates :theme, length: { maximum: 100 }, allow_blank: true
  validates :rules, length: { maximum: 1000 }, allow_blank: true
end