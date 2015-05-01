class Item < ActiveRecord::Base
  has_many :stocks
  has_many :reviews, as: :resource, class_name: ItemReview.name
  has_many :favorites, as: :resource, class_name: ItemFavorite.name
  mount_uploader :image, PictureUploader
end
