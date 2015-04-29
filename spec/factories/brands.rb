FactoryGirl.define do
  factory :brand do
    sequence(:name) { |n| "brand_name#{n}" }
    sequence(:priority) {|n| n.to_i}
  end
end
