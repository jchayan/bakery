class Oven < ActiveRecord::Base
  belongs_to :user
  has_one :sheet
  has_many :cookies, through: :sheet

  validates :user, presence: true

  DEFAULT_COOKING_TIME = 120.freeze # A couple of minutes

  def cook(cooking_time = DEFAULT_COOKING_TIME)
    CookingWorker.work(id, cooking_time)
  end
end
