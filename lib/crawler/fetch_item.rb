class Crawler::FetchItem
  USER_AGENT = 'Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_3 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B511 Safari/9537.53'

  def initialize
    @logger = Logger.new('log/crawler.log')
  end

  def run

    # chums = Site.joins(:brand).where({"brands.name" => "CHUMS"}).first
    Site.joins(:brand).each do |site|
      page_source = RestClient.get(site.url, user_agent: USER_AGENT)
      page = Nokogiri::HTML.parse(page_source, nil)
      item = page_data(page)
      item[:url] = site.url
      persist(item)
    end
  end

  private

  def persist(item)
    @logger.debug("#{Time.now}-#{item}-FAIL: fetch item") unless Item.create!(item)
  end
  
  def page_data(page)

    img_base_url = "http://www.goout.jp/client_info/GOOUT/itemimage/"
    images = []
    title = page.xpath('//div[@class="inr"]/h3').text()
    description = page.xpath('//div/p[@class="exp2"]').text()
    original_price = page.xpath('//div[@class="inr"]/p[@class="price"]').first.text().gsub(/[^0-9]/,"").to_i
    discounted = false
    item_id = page.xpath('//p[@id="itemID"]').text().downcase
    picture_descriptions = page.xpath('//div[@id="detailTxt"]/ul/li').select {|node| node.text unless node.text.empty?}
    
    picture_descriptions.each.with_index(1) do |val, index|
      images.push("#{img_base_url}#{item_id}-d#{format("%02d",index)}b.jpg")
    end
    
    {
      title: title,
      description: description,
      original_price: original_price,
      discounted: discounted,
      remote_image_url: images.first # 本来は複数画像のパスを保存したい
    }
  end
end
