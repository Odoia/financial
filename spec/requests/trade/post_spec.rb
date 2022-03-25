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
            require 'pry'; binding.pry
            expect(body['data']['amount']).to eq params[:bank_account][:amount]
          end
        end
      end

      xcontext 'When use a invalid params' do
        context 'When use a body without user' do
          let(:params) { { user_id: user.id, amount: 22.0 } }

          it 'must be return status 400' do
            expect(body['status']).to eq 400
          end
        end

        context 'When use a body without one parameter' do
          let(:params) { { 'bank_account': {} } }

          it 'must be return status 400' do
            expect(body['status']).to eq 400
          end
        end

        context 'When try send a empty body' do
          let(:params) {}

          it 'must be return status 400' do
            expect(body['status']).to eq 400
          end
        end

        xcontext 'When try send a invalid_user' do
          let(:params) { { 'bank_account': { user_id: user.id+20, amount: 22.0 } } }

          it 'must be return status 404' do
            expect(body['status']).to eq 404
          end

          it 'must be return user error' do
            result = body['errors']['user'].first
            expect(result).to eq 'must exist'
          end
        end
      end
    end
  end
end
