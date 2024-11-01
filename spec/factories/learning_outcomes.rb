FactoryBot.define do
  factory :learning_outcome do
    sum_rel_id                 {1}
    text                       {Faker::Lorem.sentence}
    score                      {Faker::Number.number(digits: 2)}
    assessment                 {Faker::Lorem.sentence}
    association :user
    association :document
  end
end
