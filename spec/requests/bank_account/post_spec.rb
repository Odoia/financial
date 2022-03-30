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
    post '/api/v1/bank_account', params: params, headers: { 'ACCEPT' => 'application/json' }
  end

  let(:body) { JSON.parse response.body }
  let(:user) { FactoryBot.create(:user) }

  context 'When create a bank account' do
    context 'When use a valid params' do
      context 'When use a POST url' do
        let(:params) { { 'bank_account': { amount: 22.0 } } }

        it 'must be return status 201' do
          expect(body['status']).to eq 201
        end

        it 'must be return a bank account amount' do
          expect(body['data']['amount']).to eq params[:bank_account][:amount]
        end
      end
    end

    context 'When use a invalid params' do
      context 'When use a body without user' do
        let(:params) { { amount: 22.0 } }

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
    end
  end
end
