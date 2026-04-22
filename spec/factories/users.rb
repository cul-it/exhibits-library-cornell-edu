# frozen_string_literal: true
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@cornell.edu" }
    password { 'password' }
  end
end
