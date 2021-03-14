# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :transactions
  has_many :account_users
  has_many :roles, through: :account_users
  has_many :users, through: :account_users
  has_many :invites
  has_many :rules, through: :account_users
  has_many :limits, through: :account_users

  def valid_thru
    created_at + 3.days
  end
end
