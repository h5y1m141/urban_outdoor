namespace :crawler do
  desc "crawler for GO OUT or something"
  task exec: :environment do
    go_out = Crawler::GoOut.new
    go_out.run
  end

  desc "fetch item"
  task fetch_item: :environment do
    crawler_fetch_item = Crawler::FetchItem.new
    crawler_fetch_item.run
  end
end
