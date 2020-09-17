class CreateSheets < ActiveRecord::Migration[5.1]
  def change
    create_table :sheets do |t|
      t.references :oven, foreign_key: true

      t.timestamps
    end
  end
end
