class Crawler::Nanga < Crawler::Base
  attr_accessor :pages, :urls
  include Crawler::Searchable
  def initialize
    super
    @base_url = 'http://nanga-schlaf.com'
  end

  def run
    fetch_pages
    insert_queue(@pages, 'nanga')
  end

  def fetch_pages
    target_url = 'http://nanga-schlaf.com/products/list.php?category_id=2'
    page = Nokogiri::HTML.parse(page_source(target_url))
    @pages = page.xpath('//div[@class="listphoto"]/a').map do |node|
      {
        brand: 'NANGA',
        url: "#{@base_url}#{node.attributes['href'].value}"
      }
    end
    @logger.debug(@pages)
  end

  def page_data(url)
    page = Nokogiri::HTML.parse(page_source(url))
    name = page.xpath('//div[@class="photo"]/a/img/@alt').text
    original_price = to_price(page.xpath('//span[@id="price02_default changefont"]').text)
    discount_price = nil
    discounted = (discount_price.nil?) ? false : true
    image = "#{@base_url}#{page.xpath('//div[@class="photo"]/a/img/@src').text}"
    images = [image]
    description = ''
    store_id = (Store.where(url: "#{@base_url}/").present?) ? Store.where(url: "#{@base_url}/").first.id : nil
    brand = (Brand.where(name: 'NANGA').present?) ? Brand.where(name: 'NANGA').first : nil
    stocks = []
    tags = []
    {
      name: name,
      images: images,
      url: url,
      description: description,
      original_price: original_price,
      discount_price: discount_price,
      discounted: discounted,
      store_id: store_id,
      brand_id: (brand.present?) ? brand.id : nil,
      stocks: stocks,
      tags: tags
    }
  end

  def fetch_stocks(page)
    sizes = page.xpath('//select[@name="classcategory_id1"]/option').map {|node| {size: node.attributes['label'].value} }.select{|obj| obj unless obj[:size] == '選択してください' }
  end
end
