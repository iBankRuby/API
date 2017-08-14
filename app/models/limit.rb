# frozen_string_literal: true

class Limit < ApplicationRecord
  acts_as_paranoid
  belongs_to :account_user, optional: true
  # has_one :account, through: :account_user

  validates :reminder, numericality: { greater_than_or_equal_to: 0 }
end
