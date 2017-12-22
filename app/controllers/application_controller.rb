class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  # Confirm a logged in user
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "controllers.application_controller.please_login"
      redirect_to login_url
    end
  end
end
