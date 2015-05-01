FactoryGirl.define do
  factory :user do
    salt = "somethingsalt"
    sequence(:email) { Faker::Internet.email }
    sequence(:first_name) { Faker::Name.first_name }
    sequence(:last_name) { Faker::Name.last_name }
    sequence(:user_name) { |n| "user_name#{n}" }
    salt salt
    crypted_password Sorcery::CryptoProviders::BCrypt.encrypt("secret", salt)
    reviews { create_list :item_review, 2 }
    favorites { create_list :item_favorite, 2 }
  end
end
