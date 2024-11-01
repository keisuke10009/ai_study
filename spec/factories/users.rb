FactoryBot.define do
  factory :user do
    nickname              {Faker::Name.initials(number: 2)}
    points                {0}
    email                 {Faker::Internet.email}
    password              {Faker::Internet.password(min_length: 6)}
    password_confirmation {password}
  end
end
