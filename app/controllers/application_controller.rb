class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :check_session_expiry

  private

  def check_session_expiry
    if session[:expires_at].present? && Time.current > session[:expires_at]
      reset_session
      render "puzzles/login"
    else
      session[:expires_at] = 1.hour.from_now
    end
  end
end
