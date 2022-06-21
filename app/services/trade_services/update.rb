module TradeServices
  class Update
    def initialize(user:, trade_params:)
      @user = User.find(user)
      @shares = trade_params['shares']
      @trade_type = trade_params['trade_type'].to_i
      @account_id = trade_params['account_id']
      @symbol = trade_params['symbol']
      @state = trade_params['state']
      @date_to_trade = trade_params['date_to_trade'] || nil
      @price = trade_params['price'].to_f
    end

    def call
      return { error: 'insufficient funds', status: 400 } if amount_to_save(price).negative?

      result = trade_create
      user_update_amount

      result
    end

    private

    attr_reader :user, :symbol, :state, :shares, :trade_type, :price, :account_id, :date_to_trade

    def trade_create
      ::Trade.new.tap do |u|
        u.shares = shares
        u.trade_type = trade_type
        u.price = price
        u.account_id = account_id
        u.symbol = symbol
        u.state = state == 'pending' ? 'done' : 'canceled'
        u.timestamp = Time.now
        u.job_token = nil
        u.save
      end
    end

    def user_update_amount
      require 'pry'; binding.pry
      current_user_bank_account.amount = amount_to_save(price)
      current_user_bank_account.save
    end

    def amount_to_save(amount_to_calculate)
      return current_user_bank_account.amount - amount_to_calculate if trade_type.zero?

      return current_user_bank_account.amount + amount_to_calculate if trade_type == 1
    end

    def current_user_bank_account
      @current_user_bank_account ||= user.bank_account.find_by(id: account_id)
    end
  end
end
