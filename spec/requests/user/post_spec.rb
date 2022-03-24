require 'rails_helper'

describe 'UserController', type: :request do

  before do
    I18n.default_locale = :en
    post '/api/v1/user', params: params, headers: { 'ACCEPT' => 'application/json' }
  end

  let(:body) { JSON.parse response.body }

  context 'When create a user' do
    context 'When use a valid params' do
      context 'When use a POST url' do
        let(:params) do
          {'user': {
            email: Faker::Internet.email,
            password: '1Asdert@',
            name: Faker::Name.first_name,
            surname: "#{Faker::Name.first_name} #{Faker::Name.last_name}"
            }
          }
        end

        it 'must be return status 201' do
          expect(body['status']).to eq 201
        end

        it 'must be return user name' do
          expect(body['data']['name']).to eq params[:user][:name]
        end

        it 'must be create a bank account to user with 1000 amount' do
          bank_account = User.find(body['data']['id']).bank_account.first
          expect(bank_account.user_id).to eq body['data']['id']
          expect(bank_account.amount).to eq 1000.0
        end
      end
    end

    context 'When use a invalid params' do
      context 'When use a body without user' do
        let(:params) { { 'name': 'user name' } }

        it 'must be return status 400' do
          expect(body['status']).to eq 400
        end
      end

      context 'When use a body without one parameter' do
        let(:params) { { 'user': {} } }

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
