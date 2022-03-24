require 'rails_helper'

describe 'AuthenticationController', type: :request do

  before do
    I18n.default_locale = :en
    post '/api/v1/authenticate', params: params, headers: { 'ACCEPT' => 'application/json' }
  end

  let(:body) { JSON.parse response.body }

  context 'When authenticate a user' do
    context 'When use a valid params' do
      context 'When use a authenticate url' do
        context 'When user is active' do
          let(:user) do
            User.create(
              email: Faker::Internet.email,
              password: '1Asdert@',
              name: Faker::Name.first_name,
              surname: "#{Faker::Name.first_name} #{Faker::Name.last_name}"
            )
          end

          let(:params) { { email: user.email, password: '1Asdert@' } }

          it 'must be return status 200' do
            expect(response.status).to eq 200
          end

          it 'must return auth_token' do
            expect(body['auth_token']).not_to be_empty
          end
        end

        context 'When user is not active' do
          let(:user) do
            User.create(
              email: Faker::Internet.email,
              password: '1Asdert@',
              is_active: false,
              name: Faker::Name.first_name,
              surname: "#{Faker::Name.first_name} #{Faker::Name.last_name}"
            )
          end

          let(:params) { { email: user.email, password: '1Asdert@' } }

          it 'must be return status 401' do
            expect(response.status).to eq 401
          end

          it 'must return invalid credentials' do
            expect(body['error']['user_authentication']).to eq 'invalid credentials'
          end
        end
      end

      context 'When use a invalid params' do
        before(:each) do
          User.create(
            email: Faker::Internet.email,
            password: '1Asdert@',
            name: Faker::Name.first_name,
            surname: "#{Faker::Name.first_name} #{Faker::Name.last_name}"
          )
        end

        context 'When use a body without user' do
          let(:params) { { 'name': 'user name' } }

          it 'must be return status 401' do
            expect(response.status).to eq 401
          end

          it 'must return invalid credentials' do
            expect(body['error']['user_authentication']).to eq 'invalid credentials'
          end
        end

        context 'When use a body without one parameter' do
          let(:params) { { 'password': '1Asdert@' } }

          it 'must be return status 401' do
            expect(response.status).to eq 401
          end

          it 'must return invalid credentials' do
            expect(body['error']['user_authentication']).to eq 'invalid credentials'
          end
        end

        context 'When try send a empty body' do
          let(:params) {}

          it 'must be return status 401' do
            expect(response.status).to eq 401
          end

          it 'must return invalid credentials' do
            expect(body['error']['user_authentication']).to eq 'invalid credentials'
          end
        end

        context 'When send a wrong password' do
          let(:params) { { 'name': 'user name', password: 'asdqwe@1' } }

          it 'must be return status 401' do
            expect(response.status).to eq 401
          end

          it 'must return invalid credentials' do
            expect(body['error']['user_authentication']).to eq 'invalid credentials'
          end
        end
      end
    end
  end
end
