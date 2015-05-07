# == Schema Information
#
# Table name: sites
#
#  id         :integer          not null, primary key
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Site < ActiveRecord::Base
  has_one :brand
end
