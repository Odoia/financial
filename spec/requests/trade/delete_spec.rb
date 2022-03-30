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

  context 'When delete a trade' do
    before do
      delete '/api/v1/trades/1', headers: { 'ACCEPT' => 'application/json' }
    end

    it 'must be return a status 405' do
      expect(body['status']).to eq 405
    end

    it 'must be return a error message' do
      expect(body['errors']).to eq 'method not allowed'
    end
  end
end
