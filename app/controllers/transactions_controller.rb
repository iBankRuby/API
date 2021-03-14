# frozen_string_literal: true

class TransactionsController < ApplicationController
  def create
    transaction_creator = TransactionCreator.new(params: params, user: current_user)
    if transaction_creator.check_creds
      transaction_creator.create_transaction
      redirect_to transaction_creator.account, notice: 'Transaction was successfully created.'
    else
      redirect_to account_path(params[:account_id]), notice: 'Transaction was NOT created.'
    end
  end

  def update
    # transaction_creator = TransactionCreator.new(params: params, user: current_user)
    # transaction_creator.confirm
  end
end
