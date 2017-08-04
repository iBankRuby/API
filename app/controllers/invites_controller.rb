class InvitesController < ApplicationController
  before_action :set_invite, only: %i[destroy update]
  before_action :set_user_to_id, only: :create
  before_action :set_current_user_id, only: %i[index create]

  attr_reader :invite, :user_to, :current_user_id

  def index
    @invites = Invite.where(user_from_id: current_user_id)
  end

  def create
    @invite = Invite.new(user_from_id: current_user_id, user_to_id: user_to, account_id: params[:account_id])
    if invite.valid?
      invite.save && redirect_to(account_invites_url, notice: 'Invite have made.')
    else
      redirect_to account_invites_url, notice: 'Invite haven\'t been made'
    end
  end

  def update
    invite.update(status: true)
    @role = Role.create(user: current_user, account_id: invite.account_id, role: 'co-user')
    redirect_to :accounts
  end

  def destroy
    # delete for now, need store rejected invites somewhere with status false??
    invite.delete && redirect_to(:accounts)
  end

  private

  def set_invite
    @invite = Invite.find(params[:id])
  end

  def invite_params
    params.fetch(:invite).permit(:email)
  end

  def set_user_to_id
    email = invite_params[:email]
    if email.blank?
      redirect_to account_invites_url, notice: 'Field should\'t be blank'
    else
      begin
        @user_to = User.find_by(email: email).id
      rescue NoMethodError
        redirect_to account_invites_url, notice: '@mail not found'
      end
    end
  end

  def set_current_user_id
    @current_user_id = current_user.id
  end
end
