# == Schema Information
#
# Table name: brands
#
#  id         :integer          not null, primary key
#  site_id    :integer
#  name       :string
#  priority   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Brand < ActiveRecord::Base
  belongs_to :site
end
