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
          valid_user = User.new(email: email, password: password, is_active: active, name: name, surname: surname)

          expect(valid_user).to be_valid
        end
      end

      context 'When register a invalid user' do
        context 'When user parameters is nil' do
          it 'should be return a active record error' do
            invalid_user = User.new(email: nil, password: nil, is_active: nil, name: nil, surname: nil)
            errors = invalid_user.errors

            expect(invalid_user).not_to be_valid
            expect(errors[:email].first).to eq "can't be blank"
            expect(errors[:password].first).to eq "can't be blank"
            expect(errors[:name].first).to eq "can't be blank"
            expect(errors[:surname].first).to eq "can't be blank"
          end
        end

        context 'When register a wrong password' do
          context 'When password has 5 characters' do
            it 'should be return a password minimum character message' do
              new_user5 = User.create(password: '12345')
              new_user9 = User.create(password: '123456789')

              expect(new_user5.errors[:password].first).to eq 'is the wrong length (should be 8 characters)'
              expect(new_user9.errors[:password].first).to eq 'is the wrong length (should be 8 characters)'
            end
          end

          context 'When password has invalid characters' do
            it 'should be return a password invalid character message' do
              new_user = User.create(password: '12345678')
              new_user2 = User.create(password: 'Aaaaaaaa')
              new_user3 = User.create(password: 'a1@fdglk')

              expect(new_user.errors[:password].first).to eq 'password must has a least 1 capital letter, 1 number and 1 special character.'
              expect(new_user2.errors[:password].first).to eq 'password must has a least 1 capital letter, 1 number and 1 special character.'
              expect(new_user3.errors[:password].first).to eq 'password must has a least 1 capital letter, 1 number and 1 special character.'
            end
          end
        end

        context 'When register a 2 equal user email' do
          it 'should be return a email unique message' do
            new_user = User.create(email: user.email)

            expect(new_user.errors[:email].first).to eq 'has already been taken'
          end
        end
      end
    end
  end
end
