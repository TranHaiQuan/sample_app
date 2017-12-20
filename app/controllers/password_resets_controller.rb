class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "controllers.password_resets_controller.sent_email"
      redirect_to root_path
    else
      flash[:danger] = t "controllers.password_resets_controller.not_found_email"
      render "new"
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can not blank")
      render "edit"
    elsif @user.upadte_attributes user_params
      log_in @user
      @user.upadte_attributes :reset_digest, nil
      flash[:success] = t "controllers.password_resets_controller.reseted"
      redirect_to @user
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_comfirmation
  end
  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to root_path
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t "controllers.password_resets_controller.expired"
      redirect_to new_password_reset_url
    end
  end
end
