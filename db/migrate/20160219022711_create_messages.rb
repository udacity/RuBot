class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :message_number
      t.text :text
      t.string :project

      t.timestamps null: false
    end
  end
end
