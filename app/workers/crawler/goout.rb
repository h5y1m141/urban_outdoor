class Crawler::Goout < Crawler::Base
  attr_accessor :pages, :urls, :brand_list
  include Crawler::Searchable

  def initialize
    super
    @base_url = "http://www.goout.jp"
    @target_brands = [
      'CHUMS'
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
    item_id = url.split('item/').last.split('.html').join.downcase
    # JavaScriptで動的に画像パスを生成する処理をしてるため、それを再現。
    # 画像の最大値を取得するのにul[@id="detailTxt"]/liの数をベースに算出してるロジックになってる
    images = page.xpath('//ul[@id="detailTxt"]/li').map.with_index do |node, index|
      detail_no_id = format('%02d', index + 1)
      "#{@base_url}/client_info/GOOUT/itemimage/#{item_id}-d#{detail_no_id}b.jpg"
    end
    description = page.xpath('//div[@class="description"]').text
    original_price = to_price(page.xpath('//section[@id="dataSect"]/dl/dd')[2].text)
    store_id = (Store.where(url: "#{@base_url}/").present?) ? Store.where(url: "#{@base_url}/").first.id : nil
    discount_price = nil
    discounted = (discount_price.nil?) ? false : true
    brand_name = page.xpath('//div[@class="brand"]').text
    brand = (Brand.where(name: brand_name).present?) ? Brand.where(name: brand_name).first : nil
    stocks = fetch_stocks(page)
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
      stocks: stocks
    }    
  end
  def fetch_stocks(page)
    colors = page.xpath().map{|node| {color: node.text} }
    sizes = []
    in_stock_labels = []
    page.xpath().each do |node|

      unless node.attributes.present?
        sizes.push({size: node.children.first.children.text.split("/").first.squish })
        in_stock_labels.push({ value: node.children.last.children.text })
      end
    end
    in_stocks = in_stock_labels.map do |label|
      if ['在庫なし'].include?label[:value]
        { in_stock: false }
      else
        { in_stock: true }
      end
    end
    stocks = []
    colors.each do |c|
      sizes.each_with_index do|s,index|
        stocks.push({
          color: c[:color],
          size: s[:size],
          in_stock: in_stocks[index][:in_stock]
        })
      end
    end
    return stocks
  end  
end
