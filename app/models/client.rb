class Client < ActiveRecord::Base

  def setup_client
    @rubot = Slack::RealTime::Client.new(websocket_ping: 40)
  end

  def get_users
    @users = User.all
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

  def set_user(data)
    #will work with responses from :team_join and :user_change events
    @user = @users.select { |person| person.slack_id == data.user.id }.first
  end

  def set_user_rubot_channel_id(data)
    #will work with responses from :team_join and :user_change events
    set_user(data)
    @user.channel_id = @rubot.web_client.im_open(user: data.user.id).channel.id
    @user.save
  end

  def send_message(channel_id, message_id)
    @rubot.web_client.chat_postMessage(
        channel: channel_id, 
        text: Message.where(id: message_id).first.text, 
        username: "RuBot")
  end

  def send_scheduled_messages(user)
    s = Rufus::Scheduler.new
    s.in '60s' do
      send_message(user.channel_id, 2)
    end
    s.in '10m' do
      send_message(user.channel_id, 3)
    end
    # s.in '1d' do
    #   send_message(user.channel_id, 4)
    # end
  end

  def send_welcome_message
    @rubot.on :user_change do |data|
      set_user(data)
      #set_user_rubot_channel_id(data)
      send_message(@user.channel_id, 1)
      send_scheduled_messages(@user)
    end
  end

  def update_user
    #Needs to be completed
    @rubot.on :user_change do |data|
    end
  end

  def start_rubot
    @rubot.start!
  end

  def bot_behavior
    # Need to figure out way to defend against lost connection.
    setup_client
    get_users
    say_hello_on_start
    log_messages
    add_new_user
    send_welcome_message
    start_rubot
  end

end
