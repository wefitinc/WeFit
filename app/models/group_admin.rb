class GroupAdmin < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :user,
    presence: true,
    uniqueness: { scope: :group }
end
