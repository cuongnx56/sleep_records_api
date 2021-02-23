FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    password { '123456789' }
  end
end
