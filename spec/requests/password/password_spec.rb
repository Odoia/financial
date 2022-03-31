require 'rails_helper'

describe 'PasswordController', type: :request do

  before do
    I18n.default_locale = :en
  end

  let(:body) { JSON.parse response.body }
  let(:user) { FactoryBot.create(:user) }
  let(:user_with_token) do
    FactoryBot.create(:user, reset_password_token: "f42c5f7b211d605b260c", reset_password_sent_at: Time.now)
  end

  context 'When user forgot password' do
    context 'When pass a valid email' do
      before do
        user
        email = { 'email': user.email }
        post '/api/v1/password/forgot', params: email, headers: { 'ACCEPT' => 'application/json' }
      end

      it 'must be return a status 200' do
        expect(response.status).to eq 200
      end

      it 'must be return a status string ok' do
        expect(body['status']).to eq 'ok'
      end
    end

    context 'When pass a invalid email' do
      before do
        email = { 'email': 'mail@mail.com' }
        post '/api/v1/password/forgot', params: email, headers: { 'ACCEPT' => 'application/json' }
      end

      it 'must be return a status 404' do
        expect(response.status).to eq 404
      end

      it 'must be return a error' do
        expect(body['error']).to eq ["Email address wrong"]
      end
    end
  end

  context 'When user reset password' do
    context 'When pass a valid param' do
      before do
        user_with_token
        params = { 'email': user.email, 'token': user_with_token.reset_password_token, 'password': 'A@as18hr' }
        post '/api/v1/password/reset', params: params, headers: { 'ACCEPT' => 'application/json' }
      end

      it 'must be return a status 200' do
        expect(response.status).to eq 200
      end

      it 'must be return a status 200' do
        expect(body['status']).to eq 'ok'
      end
    end

    context 'When pass a invalid token' do
      before do
        user_with_token
        params = { 'email': user.email, 'token': 'sdfsdfsdf232' , 'password': 'A@as18hr' }
        post '/api/v1/password/reset', params: params, headers: { 'ACCEPT' => 'application/json' }
      end

      it 'must be return a status 404' do
        expect(response.status).to eq 404
      end

      it 'must be return a status 200' do
        expect(body['error']).to eq ['Link wrong']
      end
    end
  end
end
