class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # コメントは必須、最大500文字
  validates :body, presence: true,length: { maximum: 500 }

  validate :body_must_include_text

  private

  def body_must_include_text
    if body.present? && body.match?(/\A[[:space:]]*\z/)
      errors.add(:body, "を入力してください")
    end
  end
end
