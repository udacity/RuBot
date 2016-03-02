class Message < ActiveRecord::Base

  # def self.get_users
  #   @users = User.all
  # end

  # def self.send_message_1
  #   puts "Inside of send_message_1"
  #   @users.each do |user|
  #     # if user.age < 2 && user.age > 1 
  #       if user.channel_id
  #         Client.send_message(user.channel_id, 1)
  #       else
  #         puts "Error: No channel_id set for #{user.user_name}."
  #       end
  #     # end
  #   end
  # end

  # def self.send_messages
  #   puts "Running Message.send_messages at: #{Time.now}"
  #   get_users
  #   send_message_1
  # end

end
