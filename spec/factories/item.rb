FactoryGirl.define do
  factory :item do
    sequence(:title) { |n| "title#{n}" }
    sequence(:url) { |n| "http://www.example.com/item/#{n}" }
    sequence(:description) {|n| "description#{n}"}
    stocks { create_list :stock, 5 }

    trait :on_sale do
      discounted true
      original_price 10000
      discount_price 5000
    end

    trait :off_sale do
      discounted false
      original_price 10000
    end
  end
end
