class ImageAnalyze::Cap < ImageAnalyze::Base
  def initialize(target)
    @target = target
    @items = Item.fetch_by_tags(@target[:japanese_name])
    super
  end

  def run
    super
  end

  def show
    super
  end
end

# target = {
#   english_name: 'cap',
#   japanese_name:'帽子'
# }
# ImageAnalyze::Cap.new(target)
