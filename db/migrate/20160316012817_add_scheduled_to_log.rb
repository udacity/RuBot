class AddScheduledToLog < ActiveRecord::Migration
  def change
    add_column :logs, :scheduled, :boolean, :default => false
  end
end
