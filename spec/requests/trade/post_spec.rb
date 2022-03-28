require 'rails_helper'

describe 'TradeController', type: :request do

  before do
    I18n.default_locale = :en
    bank_account
    current_user_mock
    post '/api/v1/trades', params: params, headers: { 'ACCEPT' => 'application/json' }
  end

  let(:current_user_mock) do
    allow(AuthorizeApiRequest).to receive(:call)
      .and_wrap_original do |method, *args|
        method.call(*args).tap do |obj|
          expect(obj).to receive(:result).and_return(user)
        end
      end
  end


  let(:body) { JSON.parse response.body }
  let(:user) { FactoryBot.create(:user) }
  let(:bank_account) do
    for i in 1..5 do
      FactoryBot.create(:bank_account, user_id: user.id)
    end
  end

  context 'When create a new trade' do
    context 'When use a valid params' do
      context 'When use a POST url' do
        context 'When use a buy trade_type' do
          let(:params) do
            { 'trade': { 
              shares: 22,
              trade_type: 0,
              price: 22.0,
              account_id: bank_account.last,
              symbol: 'symbol',
              state: 'done',
            }
            }
          end

          it 'must be return status 201' do
            expect(body['status']).to eq 201
          end

          it 'must be return a bank account amount' do
            expect(user.bank_account.last.amount).to eq 978.0
          end
        end

        context 'When use a sell trade_type' do
          let(:params) do
            { 'trade': { 
              shares: 22,
              trade_type: 1,
              price: 22.0,
              account_id: bank_account.last,
              symbol: 'symbol',
              state: 'done',
            }
            }
          end

          it 'must be return status 201' do
            expect(body['status']).to eq 201
          end

          it 'must be return a bank account amount' do
            expect(user.bank_account.last.amount).to eq 1022.0
          end
        end


        context 'When use a buy trade_type but don`t has money' do
          let(:params) do
            { 'trade': { 
              shares: 22,
              trade_type: 0,
              price: 2000.0,
              account_id: bank_account.last,
              symbol: 'symbol',
              state: 'done',
            }
            }
          end

          it 'must be return status 400' do
            expect(body['status']).to eq 400
          end

          it 'must be return a bank account amount' do
            expect(user.bank_account.last.amount).to eq 1000.0
          end
        end
      end
    end
  end
end
