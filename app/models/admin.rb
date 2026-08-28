class Admin < ApplicationRecord
  has_secure_password
  has_many :sessions, as: :account, dependent: :destroy
  has_many :groups, dependent: :destroy

  normalizes :email_address, with: ->(email) { email.strip.downcase }

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true
end
