# frozen_string_literal: true

class AccountUser < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  belongs_to :account, -> { with_deleted }
  belongs_to :role
  belongs_to :rule, optional: true
  has_one :limit, dependent: :destroy

  validates :user_id, presence: true
  validates :account_id, presence: true

  def role?(r)
    role.name == r
  end
end
