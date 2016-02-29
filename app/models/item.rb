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
  has_many :stocks, dependent: :delete_all
  has_many :reviews, as: :resource, class_name: ItemReview.name
  has_many :favorites, as: :resource, class_name: ItemFavorite.name
  has_many :pictures, dependent: :delete_all
  has_many :tags, dependent: :delete_all
  belongs_to :brand
  belongs_to :store
  mount_uploader :image, PictureUploader

  accepts_nested_attributes_for :stocks
  accepts_nested_attributes_for :tags
  def self.create_or_update_by_crawler(params)
    return false unless params[:url] && params[:images] && params[:stocks]
    pictures = self.prepare_pictures(params[:images], params[:url])
    item = Item.where(url: params[:url]).first_or_create(self.revised_parameter(params))
    if item.pictures.empty?
      item.pictures = pictures
      item.tap(&:save)
    end

    unless item.new_record?
      # 在庫のIDがパラメーターに含まれないため純粋な更新処理が出来ないので
      # 一度在庫を削除してから再度在庫を登録
      item.stocks.each{|stock| stock.destroy }
      item.update(params)
    end
  end

  def self.prepare_pictures(image_path_list, url)
    result = []
    image_path_list.each do |image_url|
      # ページによっては画像が存在しないケースあるので対応
      RestClient.get(image_url) do |response|
        unless response.code == 404 || response.empty?
          picture = Picture.new
          picture.remote_image_url = image_url
          picture.width = picture.image.get_dimensions.first
          picture.height = picture.image.get_dimensions.last
          picture.original_picture_url = image_url
          result.push(picture) if picture.save
        end
      end
    end
    result
  end

  def self.revised_parameter(params)
    # 1.パラメーターのimagesというkeyは存在しないためpicturesにリネーム
    # 2.Active Record Nested Attributesを利用するためにstocksのキーの名前を変更する
    params[:stocks_attributes] = params[:stocks]
    params.delete :images
    params.delete :stocks
    params.merge({
      discounted: (params[:discounted] == "" || params[:discounted] == 0) ? false : true,
    })
  end
end
