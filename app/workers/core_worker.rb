class CoreWorker < ApplicationController
  include Crawler::Searchable
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options queue: :rili, retry: 3
  recurrence { hourly }

  def initialize
    @zozotown = Crawler::Zozotown.new
  end
  def perform
    @zozotown.run
  end
end
