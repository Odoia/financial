FactoryBot.define do
  factory :trade, class: '::Trade' do
    trade_type { 0 }
    account_id { Faker::Number.number(digits: 10) }
    symbol { Faker::String.random(length: 4) }
    shades { Faker::Number.number(digits: 2) }
    price { Faker::Number.number(digits: 3) }
    state { 1 }
    timestamp { Faker::Number.number(digits: 5) }
  end
end
