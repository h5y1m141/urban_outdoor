class ImageAnalyze::Felt < ImageAnalyze::Base
  def initialize
    @target = target = {
      english_name: 'felt',
      assign_tag: 'フェルト'
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
