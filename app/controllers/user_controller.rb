class UserController < ApplicationController
  before_action :user_params, only: [:create]

  def create
    result = create_user
    if result.id.nil?
      error_handler(errors: result.errors, status: 404)
    else
      render status: 201, json: { data: result, status: 201 }
    end
  end


  private

  def user_params
    return error_handler if params[:user].blank?

    params.require(:user).permit(:email, :password, :name, :surname)
  end

  def create_user
    ::UserServices::Create.new(user_params: user_params).call
  end

  def error_handler(errors: 'bad_request', status: 400)
    render nothing: true, status: status, json: { errors: errors, status: status }
  end
end
