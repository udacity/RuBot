class CreateBlasts < ActiveRecord::Migration
  def change
    create_table :blasts do |t|
      t.text :text
      t.integer :reach

      t.timestamps null: false
    end
  end
end
