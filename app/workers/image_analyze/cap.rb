class ImageAnalyze::Cap < ImageAnalyze::Base
  def initialize
    @target = target = {
      english_name: 'cap',
      assign_tag:'帽子'
    }
    @items = Item.fetch_by_tags('帽子')
    super
  end

  def run
    super
  end

  def show
    super
  end
end
