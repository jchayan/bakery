class Cookie < ActiveRecord::Base
  belongs_to :storage, polymorphic: :true
  
  validates :storage, presence: true
  scope :in_sheet, -> (sheet_id) { where(storage_id: sheet_id) }
  scope :by_fillings, -> { group(:fillings).count }
end
