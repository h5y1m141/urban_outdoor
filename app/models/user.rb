class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :reviews, as: :resource, class_name: ItemReview.name
  has_many :favorites, as: :resource, class_name: ItemFavorite.name
end
