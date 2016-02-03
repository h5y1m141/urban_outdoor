class Crawler::Goout < Crawler::Base
  attr_accessor :pages, :urls, :brand_list
  include Crawler::Searchable

  def initialize
    super
    @base_url = "http://www.goout.jp"
    @target_brands = [
      'CHUMS'
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
end
