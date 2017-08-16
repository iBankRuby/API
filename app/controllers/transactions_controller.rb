# frozen_string_literal: true

class TransactionsController < ApplicationController
  include TransactionsHistorian

  def index
    build_responce
  end

  def create
    transaction_creator = set_transaction
    if transaction_creator.check_creds
      transaction_creator.create_transaction
      redirect_to transaction_creator.account, notice: 'Transaction was successfully created.'
    else
      redirect_to account_path(params[:account_id]),
                  notice: 'Oops! Something wrong, try again later or contact administrator'
    end
  end

  def ownerapprove
    set_transaction.approve_from_owner
    redirect_to account_path(params[:account_id]), notice: 'Transaction was approved.'
  end

  def confirm
    redirection_router(set_transaction)
  end

  def cancel
    set_transaction.cancel
    redirect_to account_path(params[:account_id]), notice: 'Transaction was cancelled.'
  end

  private

  def set_transaction
    TransactionCreator.new(params, current_user)
  end

  def redirection_router(transaction)
    account = account_path(params[:account_id])
    case transaction.confirm
    when 'canceled'
      redirect_to account, notice: 'Not enough of money.'
    when 'in_approval'
      redirect_to account, notice: 'Exceeding the limit. Approve from owner requested.'
    else
      redirect_to account, notice: 'Transaction completed successfully.'
    end
  end
end
