class AddSheetToCookie < ActiveRecord::Migration[5.1]
  def change
    add_reference :cookies, :sheet, foreign_key: true
  end
end
