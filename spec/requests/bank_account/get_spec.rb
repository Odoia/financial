require 'rails_helper'

describe 'BankAccountController', type: :request do

  before do
    I18n.default_locale = :en
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

  let(:bank_account_with_trade) do
    for i in 1..5 do
      bank = FactoryBot.create(:bank_account, user_id: user.id)
      FactoryBot.create(:trade, account_id: bank.id, symbol: 'asdew')
    end
  end

  context 'When show all bank account' do
    context 'When show all by user' do
      context 'When use a GET url' do
        context 'When user has 1 or more bank account' do
          before do
            bank_account
            get '/api/v1/bank_account', headers: { 'ACCEPT' => 'application/json' }
          end

          it 'must be return status 200' do
            expect(body['status']).to eq 200
          end

          it 'must be return 5 bank account' do
            expect(body['data'].count).to eq 5
          end

          context 'When user request especific bank accout with trades' do
            before do
              bank_account_with_trade
              get "/api/v1/bank_account/#{BankAccount.last.id}/trades", headers: { 'ACCEPT' => 'application/json' }
            end

            it 'must be return status 200' do
              expect(body['status']).to eq 200
            end

            it 'must be return one trade' do
              expect(body['data'].count).to eq 1
            end
          end
        end

        context 'When user don`t has any bank account' do
          before do
            get "/api/v1/bank_account", headers: { 'ACCEPT' => 'application/json' }
          end

          it 'must be return status 200' do
            expect(body['status']).to eq 200
          end

          it 'must be return 0 bank account' do
            expect(body['data'].count).to eq 0
            expect(body['data']).to eq []
          end
        end

        context 'When dont pass a valid user_id' do
          before do
            get "/api/v1/bank_account", headers: { 'ACCEPT' => 'application/json' }
          end

          it 'must be return status 200' do
            expect(body['status']).to eq 200
          end

          it 'must be return 0 bank account' do
            expect(body['data'].count).to eq 0
            expect(body['data']).to eq []
          end
        end
      end
    end
  end
end
