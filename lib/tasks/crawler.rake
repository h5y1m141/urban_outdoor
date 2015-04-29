namespace :crawler do
  desc "crawler for GO OUT or something"
  task exec: :environment do
    go_out = Crawler::GoOut.new
    go_out.run
  end
end
