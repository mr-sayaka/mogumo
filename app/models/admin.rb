class Admin < ApplicationRecord
  has_secure_password
  has_many :sessions, as: :account, dependent: :destroy
  has_many :groups, dependent: :destroy

  normalizes :email_address, with: ->(email) { email.strip.downcase }

  validates :name, 
            presence: true,
            length: { maximum: 15 }

  validates :email_address, 
            presence: true, 
            uniqueness: true,
            length: { maximum: 255 },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, 
            length: { minimum: 6 },
             allow_nil: true
end