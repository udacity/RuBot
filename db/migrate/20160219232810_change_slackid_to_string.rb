class ChangeSlackidToString < ActiveRecord::Migration
  def change
    change_column :users, :slack_id, :string
  end
end
