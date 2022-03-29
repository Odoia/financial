class TradeController < ApplicationController
  DEFAULT_STATE = 'pending'

  before_action :trade_params, only: [:create]

  def create
    if funds?
      result = schedule_trade
      render status: 201, json: { data: result, status: 201 }
    else
      error_handler
    end
  end

  def show 
    result = Trade.find_by(id: params[:id])

    if result
      render status: 200, json: { data: result, status: 200 }
    else
      error_handler(errors:'not_found' , status: 404)
    end
  end

  private

  attr_reader :current_user

  def trade_params
    return error_handler if params[:trade].blank?

    params
      .require(:trade)
      .permit(:shares, :trade_type, :price, :account_id, :symbol, :processing_date)
      .merge(state: DEFAULT_STATE)
  end

  def schedule_trade
    days = days_to_trade(trade_params[:processing_date])

    if days.zero?
      ScheduleJob.perform_now(@current_user.id, trade_params.as_json)
    else
      ScheduleJob.set(wait: days.day).perform_later(@current_user.id, trade_params.as_json)
    end
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

  def funds?
    return true if trade_params[:trade_type] == '1'

    result = (current_bank_account.amount - trade_params[:price].to_f)

    return false if result.negative?

    true
  end

  def current_bank_account
    @current_bank_account ||= current_user.bank_account.find_by(id: trade_params[:account_id])
  end

  def error_handler(errors: 'bad_request', status: 400)
    render nothing: true, status: status, json: { errors: errors, status: status }
  end
end
