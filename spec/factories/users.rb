# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    role { 0 }


    trait :registered do
      role { 1 }
    end

    trait :admin do
      role { 2 }
    end

    factory :registered_user, traits: [:registered]
    factory :admin, traits: [:admin]
  end
end
