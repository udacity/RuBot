class AddEnrolledToUsers < ActiveRecord::Migration
  def change
    add_column :users, :enrolled, :string
  end
end
