FactoryBot.define do
  factory :user do
    name                  { 'Username' }
    email                 { 'user@example.com' }
    password              { 'password' }
    password_confirmation { 'password' }
  end
end
