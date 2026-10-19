class User < ApplicationRecord
  has_secure_password
  has_one_attached :profile_image

  has_many :sessions, as: :account, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :groups, dependent: :destroy
  has_many :group_memberships, dependent: :destroy
  has_many :joined_groups,
           through: :group_memberships,
           source: :group
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def member_of?(group)
    group.group_memberships.exists?(
      user_id: id,
      status: "approved"
    )
  end

  normalizes :email_address, with: ->(email) { email.strip.downcase }

  # ニックネーム
  validates :name, presence: true, length: { maximum: 15 }

  # メールアドレス
  validates :email_address,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  
  # 自己紹介
  validates :introduction, length: { maximum: 250 }

  # パスワード：新規登録時は必須
  validates :password,
            presence: true,
            on: :create

  # パスワード：入力した場合は文字数と形式を検証
  validates :password,
            length: { minimum: 6 },
            format: {
              with: /\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+\z/,
              message: "は半角英字と数字を両方含めてください"
            },
            if: -> { password.present? }

  # パスワード確認：新規登録時は必須
  validates :password_confirmation,
            presence: true,
            on: :create

  # パスワードを入力した場合は確認欄との一致を検証
  validates :password,
            confirmation: true,
            if: -> { password.present? }

  # プロフィール画像
  validate :profile_image_format
  validate :profile_image_size

  private

  # 許可する画像形式
  def profile_image_format
    return unless profile_image.attached?

    allowed_types = %w[
      image/jpeg
      image/png
      image/webp
    ]

    unless allowed_types.include?(profile_image.blob.content_type)
      errors.add(
        :profile_image,
        "はJPEG、PNG、WebP形式の画像を選択してください"
      )
    end
  end

  # ファイルサイズの上限（5MB）
  def profile_image_size
    return unless profile_image.attached?

    if profile_image.blob.byte_size > 5.megabytes
      errors.add(
        :profile_image,
        "は5MB以下のファイルを選択してください"
      )
    end
  end
end