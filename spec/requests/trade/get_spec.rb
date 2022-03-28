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
  let(:trade) { FactoryBot.create(:trade) }

  context 'When show a specific trade' do
      context 'When use a GET url' do
          before do
            trade
            get "/api/v1/trades/#{trade.id}", headers: { 'ACCEPT' => 'application/json' }
          end

          it 'must be return status 200' do
            expect(body['status']).to eq 200
          end

          it 'must be return a trede naumber 1' do
            expect(body['data']['id']).to eq 1
          end
        end
      end
    end
