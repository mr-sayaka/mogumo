class Group < ApplicationRecord
  belongs_to :admin

  has_many :group_memberships, dependent: :destroy
  has_many :members,
           through: :group_memberships,
           source: :user
  has_many :posts

  validates :name,
            presence: true,
            length: { maximum: 100 }

  validates :description,
            presence: true,
            length: { maximum: 500 }

  validates :theme,
            presence: true,
            length: { maximum: 100 }

  validates :rules,
            presence: true,
            length: { maximum: 1000 }

  normalizes :name, with: ->(name) { name.strip }
end
