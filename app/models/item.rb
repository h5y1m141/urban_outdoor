class Item < ActiveRecord::Base
  has_many :stocks
  mount_uploader :image, PictureUploader
end
