class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :real_name
      t.integer :slack_id
      t.string :email

      t.timestamps null: false
    end
  end
end
