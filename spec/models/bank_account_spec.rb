require 'rails_helper'

describe :BankAccount do
  let(:user) { FactoryBot.create(:user) }

  before do
    I18n.default_locale = :en
  end

  context 'When use a BankAccount model' do
    context 'When register a new BankAccount' do
      context 'When register a valid BankAccount' do
        it 'should be return a created BankAccount' do
          user_id = user.id
          amount = 1000
          valid_bank_account = BankAccount.new(user_id: user_id, amount: amount)

          expect(valid_bank_account).to be_valid
        end
      end

      context 'When register a invalid bank account' do
        context 'When bank account parameters is nil' do
          it 'should be return a active record error' do
            invalid_bank_account = User.new(user_id: nil, amount: nil)
            errors = invalid_bank_account.errors

            expect(invalid_bank_account).not_to be_valid
            expect(errors[:user_id].first).to eq "can't be blank"
            expect(errors[:amount].first).to eq "can't be blank"
          end
        end
      end
    end
  end
end
