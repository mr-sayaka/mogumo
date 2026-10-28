class Admin < ApplicationRecord
  has_secure_password

  has_many :sessions, as: :account, dependent: :destroy
  has_many :groups, dependent: :destroy

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

  validates :password_confirmation,
            presence: true,
            if: -> { password.present? }

  normalizes :email_address, with: ->(email) { email.strip.downcase }
end