FactoryGirl.define do
  factory :site do
    sequence(:url) { |n| "url#{n}" }
    brand
  end
end
