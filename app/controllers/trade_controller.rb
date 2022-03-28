class TradeController < ApplicationController
  before_action :trade_params, only: [:create]

  def create
    days = days_to_trade(trade_params[:processing_date])
    result = ScheduleJob.set(wait: days.day).perform_later(@current_user.id, trade_params.as_json)

    render status: 201, json: { data: result, status: 201 }
  end

  def show 
    result = Trade.find_by(id: params[:id])

    if result
      render status: 200, json: { data: result, status: 200 }
    else
      error_handler(errors: result.errors, status: 404)
    end
  end

  private

  def trade_params
    return error_handler if params[:trade].blank?

    params.require(:trade).permit(:shares, :trade_type, :price, :account_id, :symbol, :state, :processing_date)
  end

  def days_to_trade(processing_date)
    return 0 if processing_date.nil?

    if processing_date&.to_date <= Date.today
      return 0
    else
      return (processing_date.to_date - Date.today).to_i
    end
  end

  def create_trade
    ::TradeServices::Create.new(user: @current_user, trade_params: trade_params).call
  end

  def error_handler(errors: 'bad_request', status: 400)
    render nothing: true, status: status, json: { errors: errors, status: status }
  end
end
