require 'rails_helper'

describe :Trade do

  before do
    I18n.default_locale = :en
  end

  context 'When use a trade model' do
    context 'When register a new trade' do
      context 'When register a valid trade' do
        it 'should be return a created trade' do
          trade_type = 0
          account_id = Faker::Number.number(digits: 10)
          symbol = Faker::String.random(length: 4)
          shares = Faker::Number.number(digits: 2)
          price = Faker::Number.number(digits: 3)
          state = 1
          timestamp = Faker::Number.number(digits: 5)
          valid_trade = Trade.new(
            trade_type: trade_type, account_id: account_id, symbol: symbol, shares: shares,
            price: price, state: state, timestamp: timestamp
          )

          expect(valid_trade).to be_valid
        end
      end

      context 'When register a invalid trade' do
        context 'When trade parameters is nil' do
          it 'should be return a active record error' do
            invalid_trade = Trade.new(
            trade_type: nil, account_id: nil, symbol: nil, shares: nil, price: nil, state: nil, timestamp: nil
          )
            errors = invalid_trade.errors

            expect(invalid_trade).not_to be_valid
            expect(errors[:trade_type].first).to eq "can't be blank"
            expect(errors[:account_id].first).to eq "can't be blank"
            expect(errors[:symbol].first).to eq "can't be blank"
            expect(errors[:shares].first).to eq "can't be blank"
            expect(errors[:price].first).to eq "can't be blank"
            expect(errors[:state].first).to eq "can't be blank"
            expect(errors[:timestamp].first).to eq "can't be blank"
          end
        end
      end
    end
  end
end
