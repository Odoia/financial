class TradeController < ApplicationController
  before_action :trade_params, only: [:create]

  def create
    result = create_trade
    if result[:error] || result.id.nil?
      return error_handler(errors: result[:error], status: 400) if result[:error]

      error_handler(errors: result.errors, status: 404)
    else
      render status: 201, json: { data: result, status: 201 }
    end
  end

  private

  def trade_params
    return error_handler if params[:trade].blank?

    params.require(:trade).permit(:shares, :trade_type, :price, :account_id, :symbol, :state)
  end

  def create_trade
    ::TradeServices::Create.new(user: @current_user, trade_params: trade_params).call
  end

  def error_handler(errors: 'bad_request', status: 400)
    render nothing: true, status: status, json: { errors: errors, status: status }
  end
end
