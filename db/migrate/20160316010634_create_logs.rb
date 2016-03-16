class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :channel_id
      t.integer :message_id
      t.datetime :delivery_time

      t.timestamps null: false
    end
  end
end
