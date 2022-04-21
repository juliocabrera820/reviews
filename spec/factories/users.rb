FactoryBot.define do
  factory :user, class: User do
    username { 'jules' }
    email { 'jules@gmail.com' }
  end

  factory :random_user, class: User do
    username { Faker::Name.female_first_name }
    email { Faker::Internet.email(domain: 'example') }
  end
end
