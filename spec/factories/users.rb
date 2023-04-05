# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    role { 0 }

    trait :admin do
      role { 1 }
    end

    factory :admin, traits: [:admin]
  end
end
