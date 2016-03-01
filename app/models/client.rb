class Client < ActiveRecord::Base

  def setup_client
    @rubot = Slack::RealTime::Client.new(websocket_ping: 40)
  end

  def get_users
    @users = User.all
  end

  def get_messages
    @messages = Message.all
  end

  def say_hello_on_start
    @rubot.on :hello do
      puts "Successfully connected, welcome '#{@rubot.self.name}' to the '#{@rubot.team.name}' team at https://#{@rubot.team.domain}.slack.com."
    end
  end

  def log_messages
    @rubot.on :message do |data|
      if data.username == "RuBot"
        puts "In channel #{data.channel}, at #{Time.now}, #{data.username} says: #{data.text}"
      end
    end
  end


  def add_new_user
    #Need to fix this to work with "data" instead of "member"
    #Needs to be tested using :team_join instead of :user_change
    @rubot.on :team_join do |data|
      unless @users.any? { |person| person.slack_id == data.user.id }
        @user = User.new(
          user_name: data.user.name,
          real_name: data.user.profile.real_name,
          slack_id:  data.user.id,
          email:     data.user.profile.email
        )
        @user.save
      end
    end
  end

  def send_welcome_message
    @rubot.on :team_join do |data|
      channel_id = @rubot.web_client.im_open(user: data.user.id).channel.id
      @rubot.web_client.chat_postMessage(channel: channel_id, text: @messages[0].text, username: "RuBot")
    end
  end

  def update_user
    #Needs to be completed
    @rubot.on :user_change do |data|
    end
  end

  def send_message_2

  end

  def start_rubot
    @rubot.start!
  end

  def bot_behavior
    # Need to figure out way to defend against lost connection.
    setup_client
    get_users
    get_messages
    say_hello_on_start
    log_messages
    add_new_user
    send_welcome_message
    start_rubot
  end

end
