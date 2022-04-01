require 'rails_helper'

describe 'TradeController', type: :request do

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
  let(:bank_account) { FactoryBot.create(:bank_account, user_id: user.id) }
  let(:trade) { FactoryBot.create(:trade_with_job_token, trade_type: 0, account_id: bank_account.id) }
  let(:new_params) do
    { 'trade': {
      shares: 22,
      trade_type: 1,
      price: 22.0,
      account_id: trade.account_id,
      symbol: 'symbol',
      state: 'done',
      processing_date: '12/12/2022'
      }
    }
  end

  context 'When put a trade' do
    before do
      trade
      put "/api/v1/trades/#{trade.id}", params: new_params, headers: { 'ACCEPT' => 'application/json' }
    end

    it 'must be return a status 200' do
      expect(body['status']).to eq 200
    end

    it 'must be return a error message' do
      expect(body['data']['trade_type']).to eq 'sell'
    end
  end

  context 'When patch a trade' do
    before do
      patch '/api/v1/trades/1', headers: { 'ACCEPT' => 'application/json' }
    end

    it 'must be return a status 405' do
      expect(body['status']).to eq 405
    end

    it 'must be return a error message' do
      expect(body['errors']).to eq 'method not allowed'
    end
  end
end
