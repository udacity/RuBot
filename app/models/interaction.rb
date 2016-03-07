class Interaction < ActiveRecord::Base
  validates_presence_of :user_input, :response
  def user_input=(val)
    write_attribute(:user_input, val.downcase)
  end
end
