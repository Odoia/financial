module BankAccountServices
  class Create
    def initialize(bank_account_params)
      bank_account_params = bank_account_params[:bank_account_params]
      @user_id = bank_account_params['user_id']
      @amount = bank_account_params['amount']
    end

    def call
      bank_account_create
    end

    private

    attr_reader :user_id, :amount

    def bank_account_create
      ::BankAccount.new.tap do |u|
        u.user_id = user_id
        u.amount = amount
        u.save
      end
    end
  end
end
