class Oven < ActiveRecord::Base
  belongs_to :user
  has_one :cookie, as: :storage

  validates :user, presence: true

  COOKING_TIME = 120.freeze

  def cook
    CookingWorker.perform_async(id, COOKING_TIME)
  end

  def cook!(time)
    sleep(time)
    cookie.cook!
  end
end
