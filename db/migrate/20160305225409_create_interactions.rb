class CreateInteractions < ActiveRecord::Migration
  def change
    create_table :interactions do |t|
      t.string :user_input
      t.text :response

      t.timestamps null: false
    end
  end
end
