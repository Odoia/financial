class Trade < ApplicationRecord
  validates :trade_type, :account_id, :symbol, :shares, :price, :state, :timestamp, presence: true

  enum trade_type: { buy: 0, sell: 1 }
  enum state: { done: 0, pending: 1, canceled: 2 }
end
