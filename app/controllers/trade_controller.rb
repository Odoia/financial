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
      error_handler(errors: 'not_found' , status: 404)
    end
  end

  def show_all_by_user
    trade_type = request.query_parameters['trade_type?']
    return show_all_by_trade_type(trade_type) if request.query_parameters['trade_type?']

    result = Trade.where(id: @current_user.bank_account.ids)
    render status: 200, json: { data: result, status: 200 }
  end

  def all_trades
    result = Trade.all
    render status: 200, json: { data: result, status: 200 }
  end

  def delete
    error_handler(errors: 'method not allowed', status: 405)
  end

  def update
    result = Trade.find_by(id: params['id'])

    return 'not permit' if result&.job_token.nil?

    schedule = ::Sidekiq::ScheduledSet.new
    job_to_delete = schedule.select { |job| job.item['args'].first['job_id'] == result.job_token }
    job_to_delete.each(&:delete)

    schedule_result = schedule_trade

    render status: 200, json: { data: schedule_result, status: 200 }
  end

  def patch
    error_handler(errors: 'method not allowed', status: 405)
  end

  private

  attr_reader :current_user

  def show_all_by_trade_type(trade_type)
    result = Trade.where(trade_type: trade_type)
    render status: 200, json: { data: result, status: 200 }
  end

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
      trade_with_done_status = trade_params.merge(state: 'done')
      create_trade(trade_with_done_status)
    else
      trade_scheduled = ScheduleJob.set(wait: days.day).perform_later(@current_user.id, trade_params.as_json)

      trade_with_schedule_token = trade_params.merge(job_token: trade_scheduled.job_id)
      create_trade(trade_with_schedule_token)
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

  def create_trade(params_to_create)
    ::TradeServices::Create.new(user: @current_user.id, trade_params: params_to_create).call
  end


  def funds?
    return true if trade_params[:trade_type] == '1'

    bank_account = current_bank_account
    return false if bank_account.nil?

    result = (bank_account.amount - trade_params[:price].to_f)

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
