class Article < ActiveRecord::Base
  has_many :elements, class_name: ArticleElement.name, dependent: :destroy
  has_many :items, class_name: ArticleItemRelay.name, dependent: :destroy
  has_many :pictures, class_name: ArticlePictureRelay.name, dependent: :destroy
end
