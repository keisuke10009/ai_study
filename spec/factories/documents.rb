FactoryBot.define do
  factory :document do
    title                     {Faker::Name.name}
    document                  {Faker::Lorem.sentence}
    vocabulary                {Faker::Lorem.sentence}
    summary_ai                {Faker::Lorem.sentence}
    reflection_essay_ai       {Faker::Lorem.sentence}
    level_id                  {Faker::Number.between(from: 1, to: 2)}
    category_id               {Faker::Number.between(from: 1, to: 2)}
  end
end
