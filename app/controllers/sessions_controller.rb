class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user_email = auth.info.email

    domain_allowlist = ENV.fetch("DOMAIN_ALLOWLIST").split(",").map(&:strip)
    if domain_allowlist.present?
      unless domain_allowlist.any? { |domain| user_email.end_with?("@#{domain}") }
        reset_session
        flash[:error] = "Access denied. Please access with a valid email address."
        redirect_to root_path
        return
      end
    end

    session[:user_token] = auth.credentials.token
    session[:user_email] = user_email
    redirect_to root_path
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
