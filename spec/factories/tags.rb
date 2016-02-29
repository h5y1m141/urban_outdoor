FactoryGirl.define do
  factory :tag do
    name { %w(セルビッチデニム クラシック ヘビーデューティー ミリタリーテイスト ドレッシー クロスオーバー ヴィンテージ).sample }
    item nil
  end
end
