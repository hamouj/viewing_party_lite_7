# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password_digest { BCrypt::Password.create(Faker::Internet.password) }
  end
end
