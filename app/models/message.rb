class Message < ActiveRecord::Base

  def get_users
    @users = User.all
  end

  def send_message_2
    #number of days to wait to send the message
    message_age = 2
    @users.each do |user|
      #if Time.now - user.created_at < 2 days
      end
    end
  end

  def send_messages
    get_users
    send_message_2
  end

end
