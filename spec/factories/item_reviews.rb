FactoryGirl.define do
  factory :item_review do
    sequence(:resource_id) { |n| n }
    sequence(:resource_type) { |n| "title#{n}" }
    sequence(:comment) { |n| "comment#{n}" }
  end
end
