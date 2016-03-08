class Tag < ActiveRecord::Base
  include TagSearchModule
  belongs_to :item
end
