class Crawler::Zozotown < Crawler::Base
  attr_accessor :pages, :urls, :brand_list
  include Crawler::Searchable

  def initialize
    super
    @base_url = "http://zozo.jp"
    @target_brands = [
      'adidas',
      'New Balance',
      'OAKLEY'
    ]
  end
  def run
    fetch_brands
    fetch_pages
    insert_queue(@pages, 'zozotown')
  end

  def fetch_brands
    url = "http://zozo.jp/brand/default.html?c=SwitchType&ts=2&p_no=1"
    page = Nokogiri::HTML.parse(page_source(url))
    brands = page.xpath('//div[@id="listItem"]/div/dl/dd/a').map do |node|
      {
        url: "#{@base_url}#{node.attributes['href'].value}",
        name: node.children.text
      }
    end
    @brand_list = brands.select{|brand| brand if @target_brands.include?(brand[:name])}
    insert_queue(@brand_list, 'zozotown-brand')
    page = nil
  end

  def fetch_pages
    pages = []
    categories = [
      "tops",
      "jacket-outerwear",
      "pants",
      "allinone-salopette",
      "skirt",
      "onepiece",
      "suit",
      "bag",
      "shoes",
      "fashion-accessories",
      "wallet-accessory",
      "wrist-watch",
      "hair-accessory",
      "accessory",
      "underwear",
      "leg-wear",
      "hat",
      "interior",
      "tableware-kitchenware",
      "zakka-hobby-sports",
      "cosmetics-perfume",
      "music-books",
      "swimwear-kimono-yukata",
      "maternity-baby",
      "others"
    ]
    @brand_list.each do |brand|
      categories.each do |category|
        target_url = "#{brand[:url]}#{category}/"
        page = Nokogiri::HTML.parse(page_source(target_url))
        page_links = []
        page.xpath('//ul[@id="searchResultList"]/li/div/p/a/@href').each do |node|
          page_links.push({ category: category, brand: brand[:name], url: "#{@base_url}#{node.text}"})
        end
        pages.push(page_links)
        sleep(@sleep_time)
      end
    end
    @pages = pages.flatten
    @logger.debug(@pages)
    return
  end

  def page_data(url)
    charset = 'Shift_JIS'
    page = Nokogiri::HTML.parse(page_source(url), nil, charset)
    name = page.xpath('//div[@id="item-intro"]/h1').text
    images = page.xpath('//ul[@id="photoThimb"]/li/div/span/img/@src').map {|node| node.text.gsub("D_35.jpg","D_500.jpg") }
    image_url = images.first
    store_id = (Store.where(url: "#{@base_url}/").present?) ? Store.where(url: "#{@base_url}/").first.id : nil
    brand_name = page.xpath('//div[@id="item-intro"]/ul[@id="nameList"]/li').map{|node| node.children[1].text.squish if node.children[0].text.squish == 'ブランド：'}.select{|obj| obj unless obj.nil?}.first
    brand = (Brand.where(name: brand_name).present?) ? Brand.where(name: brand_name).first : nil
    
    if page.xpath('//p[@class="price discount"]').present?
      discount_price = page.xpath('//p[@class="price discount"]').first.children[1].text.gsub(/[^0-9]/,"").to_i
      original_price = page.xpath('//p[@class="price discount"]').first.children[0].text.encode("UTF-16BE", "UTF-8", invalid: :replace, undef: :replace, :replace => '').encode("UTF-8").squish.gsub(/[^0-9]/,"").to_i
    else    
      discount_price = nil
      original_price = page.xpath('//p[@class="price"]').text.gsub(/[^0-9]/,"").to_i
    end    
    description = page.xpath('//div[@class="contbox"]').text.squish
    discounted = (discount_price.nil?) ? false : true
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
  private

  def fetch_stocks(page)
    colors = page.xpath('//div[@class="cartBlock clearfix"]/div/dl/dt/span[@class="txt"]').map{|node| {color: node.text} }
    sizes = []
    in_stock_labels = []
    page.xpath('//div[@class="cartBlock clearfix"]/div/dl/dd/ul/li/div/div/p').each do |node|
      # 該当のサイズがsoldoutの場合に
      # p class='soldout'
      # という形でクラス属性が付与されて、その項目分余計な値が取得されてしまうために以下判定処理を入れてます
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
