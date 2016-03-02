class CoreWorker
  include Crawler::Searchable
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options queue: :urban_outdoor, retry: 1
  # recurrence { daily.hour_of_day(3, 6, 9, 12, 15, 18, 21) }
  recurrence { hourly }

  def initialize
    @nanga    = Crawler::Nanga.new
    @goout    = Crawler::Goout.new
    @zozotown = Crawler::Zozotown.new
    puts 'CoreWorker init done'
  end
  def perform
    @nanga.run
    @goout.run
    # @zozotown.run
  end
end
