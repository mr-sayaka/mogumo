class User < ApplicationRecord
  has_secure_password

  has_one_attached :profile_image

  has_many :sessions, as: :account, dependent: :destroy

  has_many :posts, dependent: :destroy

  normalizes :email_address, with: ->(email) { email.strip.downcase }

  validates :name, presence: true

  validates :email_address,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password,
            presence: true,
            length: { minimum: 6 },
            allow_nil: true
end