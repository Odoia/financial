class BankAccountController < ApplicationController
  before_action :bank_account_params, only: [:create]

  def create
    result = create_bank_account
    if result.id.nil?
      error_handler(errors: result.errors, status: 404)
    else
      render status: 201, json: { data: result, status: 201 }
    end
  end

  def show_all_by_user
    result = ::BankAccount.where(user_id: params['id'])
    render status: 200, json: { data: result, status: 200 }
  end

  private

  def bank_account_params
    return error_handler if params[:bank_account].blank?

    params.require(:bank_account).permit(:user_id, :amount)
  end

  def create_bank_account
    ::BankAccountServices::Create.new(bank_account_params: bank_account_params).call
  end

  def error_handler(errors: 'bad_request', status: 400)
    render nothing: true, status: status, json: { errors: errors, status: status }
  end
end
