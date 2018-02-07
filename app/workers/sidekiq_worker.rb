class SidekiqWorker

  include ::Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options retry: false

  def debug(msg)
    puts "#{Time.now} : DEBUG : #{msg}"
  end

  def error(msg)
    puts "#{Time.now} : ERROR : #{msg}"
  end

end