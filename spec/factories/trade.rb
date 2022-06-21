FactoryBot.define do
  factory :trade, class: '::Trade' do
    trade_type { 0 }
    account_id { Faker::Number.number(digits: 4) }
    symbol { Faker::String.random(length: 3) }
    shares { Faker::Number.number(digits: 2) }
    price { Faker::Number.number(digits: 1) }
    state { 1 }
    timestamp { Faker::Number.number(digits: 5) }
  end


  factory :trade_with_job_token, class: '::Trade' do
    trade_type { 0 }
    account_id { Faker::Number.number(digits: 4) }
    symbol { Faker::String.random(length: 3) }
    shares { Faker::Number.number(digits: 2) }
    price { Faker::Number.number(digits: 1) }
    state { 1 }
    timestamp { Faker::Number.number(digits: 5) }
    job_token { Faker::Number.number(digits: 3) }
  end
end
