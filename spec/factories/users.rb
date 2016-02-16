FactoryGirl.define do
  factory :user do
    sequence(:email){ |n| "admin#{n}@urban-outdoor.info" }
    password 'password'    
  end
end
