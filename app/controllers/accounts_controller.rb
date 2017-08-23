class AccountsController < ApplicationController
  before_action :set_account, only: %i[show destroy]
  before_action :set_user_role, only: %i[show]
  before_action :set_couser_remainder, only: %i[show]
  attr_reader :accounts, :account, :income

  def index
    accounts_list
    invites_list
    @exceeding_request = ExceedingRequest.exceeding_requests_for(user)
  end

  def create
    iban = Ibandit::IBAN.new(country_code: 'BE',
                             account_number: Forgery('credit_card').number)
    account = Account.create!(iban: iban.iban,
                              balance: 1000)
    account.account_users.create(user: user, role_id: Role.find_by(name: 'owner').id)
    redirect_to account, notice: 'Account was successfully created.'
  end

  def show
    accounts_list
    outgoing_transactions_list
    incoming_transactions_list
  end

  def update
    Account.friendly.restore(params[:id], recursive: true)
    redirect_to accounts_url
  end

  def destroy
    account.destroy
    redirect_to accounts_url
  end

  private

  def set_user_role
    @role = user.role_for(account).name
  rescue RecordNotFound
    redirect_to accounts_path
  end

  def set_account
    @account ||= Account.friendly.find(params[:id])
  end

  def user
    @user ||= current_user
  end

  def accounts_list
    @accounts = user.accounts.to_a
  end

  def invites_list
    @invites ||= Invite.where(user_to_email: user.email, status: 'pending')
  end

  def outgoing_transactions_list
    @transactions = Transaction.where(user_id: user.id,
                                      account_id: account.id)
  end

  def incoming_transactions_list
    @income = Transaction.where(remote_account_iban: account.iban.to_s,
                                status_from: 'approved')
  end

  def set_role
    @role ||= @account.account_users.find_by(user_id: current_user.id).role_id
  rescue NoMethodError
    redirect_to accounts_url
  end

  def set_couser_remainder
    @couser_remainder = if @role == "co-user"
      @account.account_users.find_by(user_id: current_user.id).limit.reminder
    else
      nil
    end
  end
end
