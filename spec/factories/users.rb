FactoryBot.define do
  factory :user, class: User do
    username { 'jules' }
    email { 'jules@gmail.com' }
    password { '12345 '}
  end

  factory :random_user, class: User do
    username { Faker::Name.female_first_name }
    email { Faker::Internet.email(domain: 'example') }
    password { Faker::Internet.password(min_length: 8) }
  end
end
