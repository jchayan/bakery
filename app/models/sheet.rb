class Sheet < ApplicationRecord
  belongs_to :oven, required: false
  has_many :cookies, as: :storage

  def ready?
    cookies.to_a.all?(&:ready?)
  end
end
