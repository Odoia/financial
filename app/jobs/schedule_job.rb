class ScheduleJob < ApplicationJob
  queue_as :default

  def perform(current_user, trade_params)
    schedule_trade(current_user, trade_params)
  end

  private

  def schedule_trade(current_user, trade_params)
    ::TradeServices::Create.new(user: current_user, trade_params: trade_params).call
  end
end
