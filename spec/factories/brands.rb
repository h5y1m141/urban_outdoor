FactoryGirl.define do
  factory :brand do
    sequence(:name) { |n| "brand_name#{n}" }
  end
end
