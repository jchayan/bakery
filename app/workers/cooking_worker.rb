class CookingWorker
  include Sidekiq::Worker

  def perform(oven_id, cooking_time)
    oven = Oven.find(oven_id)
    oven.cook!(cooking_time)
  end
end
