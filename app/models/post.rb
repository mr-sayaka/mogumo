class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true

  has_one_attached :image

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  # 必須項目
  validates :title, presence: true, length: { maximum: 100 }
  validates :introduction, presence: true, length: { maximum: 1000 }
  validates :ingredients, presence: true, length: { maximum: 2000 }
  validates :how_to_make, presence: true, length: { maximum: 3000 }
  validates :target_age, presence: true

  # 公開範囲
  validates :visibility,
            presence: true,
            inclusion: { in: %w[public group] }

  # 対象年齢
  validates :target_age,
            inclusion: {
              in: ["5〜6ヶ月", "7〜8ヶ月", "9〜11ヶ月", "1歳〜"]
            }

  # 公開範囲に応じたコミュニティーの必須チェック
  validates :group_id, presence: true, if: :group_visibility?

  # 画像のバリデーション
  validate :image_presence
  validate :image_format
  validate :image_size

  # コミュニティー限定投稿かどうか
  def group_visibility?
    visibility == "group"
  end

  private

  # 画像の必須チェック
  def image_presence
    errors.add(:image, "を選択してください") unless image.attached?
  end

  # 許可する画像形式
  def image_format
    return unless image.attached?

    allowed_types = %w[
      image/jpeg
      image/png
      image/webp
    ]

    unless allowed_types.include?(image.blob.content_type)
      errors.add(:image, "はJPEG、PNG、WebP形式の画像を選択してください")
    end
  end

  # ファイルサイズの上限（5MB）
  def image_size
    return unless image.attached?

    if image.blob.byte_size > 5.megabytes
      errors.add(:image, "は5MB以下のファイルを選択してください")
    end
  end
end