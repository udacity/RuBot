class Interaction < ActiveRecord::Base
  validates_presence_of :user_input, :response

  def user_input=(val)
    write_attribute(:user_input, val.downcase)
  end

  def self.hits_per_week(i)
    if Time.now - i.created_at < 604800
      "Not enough data yet"
    else
      (i.hits/((Time.now - i.created_at)/604800)).round(2)
    end
  end

end
