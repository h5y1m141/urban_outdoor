# == Schema Information
#
# Table name: items
#
#  id             :integer          not null, primary key
#  title          :string           not null
#  url            :string           not null
#  original_price :integer
#  discounted     :boolean
#  discount_price :integer
#  description    :text
#  image          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Item < ActiveRecord::Base
  has_many :stocks
  has_many :reviews, as: :resource, class_name: ItemReview.name
  has_many :favorites, as: :resource, class_name: ItemFavorite.name
  mount_uploader :image, PictureUploader
end
