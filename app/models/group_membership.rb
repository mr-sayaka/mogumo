class GroupMembership < ApplicationRecord
  belongs_to :group
  belongs_to :user

  validates :status, presence: true, inclusion: { in: %w[pending approved rejected] }

  validates :user_id,
            uniqueness: { scope: :group_id }
end
