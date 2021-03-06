class Crawler::Goout < Crawler::Base
  attr_accessor :pages, :urls, :brand_list
  include Crawler::Searchable

  def initialize
    super
    @base_url = "http://www.goout.jp"
    @target_brands = [
      'Clef',
      'CHUMS',
      'inhabitant'
    ]
  end
  def run
    fetch_brands
    fetch_pages
    insert_queue(@pages, 'goout')
  end
  def fetch_brands
    url = 'http://www.goout.jp/brand/'
    page = Nokogiri::HTML.parse(page_source(url))
    brands = page.xpath('//ul[@class="clearfix listBox"]/li/a').map do |node|
      {
        url: "#{node.attributes['href'].value}",
        name: node.children.text
      }
    end
    @brand_list = brands.select{|brand| brand if @target_brands.include?(brand[:name])}
    insert_queue(@brand_list, 'goout-brand')
    page = nil
  end

  def fetch_pages
    pages = []
    @brand_list.each do |brand|
      target_url = "#{brand[:url]}?SEARCH_MAX_ROW_LIST=100&item_list_mode=&sort_order=1&request=page&next_page=1" 
      page = Nokogiri::HTML.parse(page_source(target_url))
      page_links = []
      page.xpath('//ul[@class="itemList"]/li/a').each do |node|
        page_links.push({brand: brand[:name], url: node.attributes['href'].value})
      end
      pages.push(page_links)
      sleep(@sleep_time)
    end

    @pages = pages.flatten
    @logger.debug(@pages)
    return
  end

  def page_data(url)
    page = Nokogiri::HTML.parse(page_source(url))
    name = page.xpath('//section[@id="detailSect"]/h2').text
    item_id = url.split('/').last.split('.html').join.downcase
    # JavaScriptで動的に画像パスを生成する処理をしてるため、それを再現。
    # 画像の最大値を取得するのにul[@id="detailTxt"]/liの数をベースに算出してるロジックになってる
    images = page.xpath('//ul[@id="detailTxt"]/li').map.with_index do |node, index|
      detail_no_id = format('%02d', index + 1)
      "#{@base_url}/client_info/GOOUT/itemimage/#{item_id}-d#{detail_no_id}b.jpg"
    end
    description = page.xpath('//div[@class="description"]').text
    store_id = (Store.where(url: "#{@base_url}/").present?) ? Store.where(url: "#{@base_url}/").first.id : nil
    prices = fetch_price(page)
    brand_name = page.xpath('//div[@class="brand"]').text
    brand = Brand.find_or_create_by(name: brand_name)
    stocks = fetch_stocks(page)
    tags = fetch_tags(page)

    {
      name: name,
      images: images,
      url: url,
      description: description,
      original_price: prices[:original_price],
      discount_price: prices[:discount_price],
      discounted: prices[:discounted],
      store_id: store_id,
      brand_id: (brand.present?) ? brand.id : nil,
      stocks: stocks,
      tags: tags
    }
  end
  def fetch_stocks(page)
    sizes = page.xpath('//div[@id="selectItem"]/table/tr')[0].children.map{|node| node.text.squish}.select{|size| size unless size.empty?}
    stocks = []
    page.xpath('//div[@id="selectItem"]/table/tr').each do |tr|
      unless tr.xpath('td').empty?
        tr.xpath('td').each_with_index do |node, index|
          size = sizes[index]
          in_stock = (node.text.squish != '×')
          stocks.push({size: size, color: tr.xpath('th').text.squish, in_stock: in_stock})
        end
      end
    end
    return stocks
  end
  def fetch_price(page)
    if(page.xpath('//div[@class="price"]/span/span[@class="proper"]').text.empty?)
      original_price = to_price(page.xpath('//section[@id="dataSect"]/dl/dd')[2].text)
      discount_price = nil
    else
      original_price = to_price(page.xpath('//div[@class="price"]/span/span[@class="proper"]').text.squish)
      discount_price = to_price(page.xpath('//div[@class="price"]/span/span[@class="saleprice"]').first.children[0].text.squish)
    end
    discounted = (discount_price.nil?) ? false : true
    {
      original_price: original_price,
      discount_price: discount_price,
      discounted: discounted
    }
  end

  def fetch_tags(page)
    categories = page.xpath('//section[@id="relatedCategroySect"]/ul/li/span/a').map do |node|
      {name: node.text}
    end
    return categories.select{|tag| tag unless tag[:name]== 'ファッション'}
  end
end
