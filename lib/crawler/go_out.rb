class Crawler::GoOut
  USER_AGENT = 'Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_3 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B511 Safari/9537.53'

  def initialize
    @logger = Logger.new('log/crawler.log')
  end

  def run
    brand_list = RestClient.get('http://www.goout.jp/brand/', user_agent: USER_AGENT)
    doc = Nokogiri::HTML.parse(brand_list, nil)
    links = doc.xpath('//ul[@class="listBox"]/li/a/@href').map {|node| node.text()}
    brands = doc.xpath('//ul[@class="listBox"]/li/a/text()').map {|node| node.text()}
    brands.zip(links).each do |brand, link|
      fetch_product_page_links(brand, link)
      sleep 4
    end
  end

  def fetch_product_page_links(brand, link)
    page = 1
    target = "#{link}?SEARCH_MAX_ROW_LIST=10&item_list_mode=&sort_order=1&request=page&next_page=#{page}"
    RestClient.get(target, user_agent: USER_AGENT) do |response|
      if response.code == 200
        doc = Nokogiri::HTML.parse(response, nil)
        links = doc.xpath('//div[@id="item_list"]/ul/li/a/@href').map {|node| node.text()}
        links.each do |link|
          Site.where(url: link).first_or_create
        end
      else
        @logger.debug("#{Time.now}-#{target}-#{response.code}")
      end
    end
  end

  private

  def persist

  end

end
