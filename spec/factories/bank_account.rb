FactoryBot.define do
  factory :bank_account, class: '::BankAccount' do
    user_id { FactoryBot.create(:user).id }
    amount { 1000 }
  end
end
