class CookingWorker
  include Sidekiq::Worker

  class << self
    def work(oven_id, cooking_time)
      perform_async(oven_id, cooking_time)
    end
  end

  def perform(oven_id, cooking_time)
    @shutdown_time = Time.now + cooking_time

    oven = Oven.find_by(id: oven_id)
    puts "Turning on Oven #{oven_id}"
    cook(oven.sheet)
  end

  private

  def cook(sheet)
    Thread.abort_on_exception = true
    # All cookies are cooking in parallel
    cookies = sheet.cookies
    threads = cookies.map { |cookie| cooking_thread(cookie) }
    threads.each(&:join)

    cookies.each(&:save)
    puts "Ding! #{cookies.length} cookies have been cooked!"
  end

  def cooking_thread(cookie)
    Thread.new(cookie) do |cookie|
      Thread.pass until ready?
      done(cookie)
    end
  end

  def ready?
    Time.now >= @shutdown_time
  end

  def done(cookie)
    cookie.ready = true
  end
end
