# == Schema Information
#
# Table name: users
#
#  id                              :integer          not null, primary key
#  email                           :string           not null
#  crypted_password                :string
#  salt                            :string
#  first_name                      :string
#  last_name                       :string
#  user_name                       :string
#  created_at                      :datetime
#  updated_at                      :datetime
#  remember_me_token               :string
#  remember_me_token_expires_at    :datetime
#  reset_password_token            :string
#  reset_password_token_expires_at :datetime
#  reset_password_email_sent_at    :datetime
#

class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :reviews, as: :resource, class_name: ItemReview.name
  has_many :favorites, as: :resource, class_name: ItemFavorite.name
end
