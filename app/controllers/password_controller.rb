class PasswordController < ApplicationController
  def forgot
    if params[:email].blank?
      return render json: { error: 'Email not present'}
    end

    user = User.find_by(email: params[:email])

    if user.present?
      user.generate_password_token!
      render status: 200, json: { status: 'ok' }
    else
      render status: 404, json: { error: ['Email address wrong'] }
    end
  end

  def reset
    token = params[:token].to_s

    if params[:email].blank?
      return render json: { error: 'Token not present' }
    end

    user = User.find_by(reset_password_token: token)

    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password])
        render status: 200, json: { status: 'ok' }
      else
        render status: 400, json: { error: user.errors.full_messages }
      end
    else
      render status: 404, json: { error: ['Link wrong'] }
    end
  end
end
