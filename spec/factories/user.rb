FactoryBot.define do
  factory :user, class: '::User' do
    email { Faker::Internet.email }
    password { 'Test@123' }
    is_active { true }
    name { Faker::Name.first_name }
    surname { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
  end
end
