require 'rails_helper'

describe :User do
  let(:user) { FactoryBot.create(:user) }

  before do
    I18n.default_locale = :en
  end

  context 'When use a User model' do
    context 'When register a new user' do
      context 'When register a valid user' do
        it 'should be return a created user' do
          email = Faker::Internet.email
          password = 'Test@123'
          active = true
          name = Faker::Name.first_name
          surname = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
          valid_user = User.new(email: email, password: password, active: active, name: name, surname: surname)

          expect(valid_user).to be_valid
        end
      end

      context 'When register a invalid user' do
        context 'When user parameters is nil' do
          it 'should be return a active record error' do
            invalid_user = User.new(email: nil, password: nil, active: nil, name: nil, surname: nil)

            expect(invalid_user).not_to be_valid
          end
        end

        context 'When register a 2 equal user email' do
          it 'should be return a email unique message' do
            user
            expect(FactoryBot.create(:user, email: user.email)).to eq 'email in use'

          end
        end
      end
    end
  end
end
