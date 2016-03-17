class Client < ActiveRecord::Base

  def setup_client
    puts "setup rubot!"
    @rubot = Slack::RealTime::Client.new(websocket_ping: 40)
    # Override the CA_FILE and CA_PATH in the embedded web client if they are set in the environment
    if ENV['CA_FILE'] and ENV['CA_PATH']    
        web_client = Slack::Web::Client.new(ca_file: ENV['CA_FILE'], ca_path: ENV['CA_PATH'])
        @rubot.web_client = web_client
    end
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
      if data.user == "U0RDVBPCH"
        puts "In channel #{data.channel}, at #{Time.now}, #{data.user} says: #{data.text}"
      end
    end
  end

  def add_new_user
    @rubot.on :team_join do |data|
      get_users
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
    get_users
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
      #username: "RuBot"
      as_user: true,
      unfurl_links: false,
      unfurl_media: false
      )
  end

  def send_scheduled_messages
    @rubot.on :user_change do |data|
      sleep(5)
      set_user_rubot_channel_id(data)
      @messages = Message.all.sort
      @messages.each do |message|
        #message_number is "delay" in seconds.
        delivery_time = Time.now + message.message_number
        @log = Log.new(
          channel_id: @user.channel_id,
          message_id: message.id,
          delivery_time: delivery_time
        )
        @log.save
        s = Rufus::Scheduler.new
        s.in message.delay do
          send_message(@user.channel_id, message.id)
          Log.where(message_id: message.id).first.delete
        end
      end
    end
  end

  def reschedule_messages
    Log.all.each do |log|
      if log.delivery_time > Time.now
        s = Rufus::Scheduler.new
        s.at log.delivery_time do
          send_message(log.channel_id, log.message_id)
          log.delete
        end
      end
    end
  end

  def update_user
    @rubot.on :user_change do |data|
      puts "A user changed! (And I'm still running. Yay!)"
      set_user(data)
      @user.user_name = data.user.name
      @user.real_name = data.user.profile.real_name
      @user.slack_id =  data.user.id
      @user.email =     data.user.profile.email
      @user.save
    end
  end

  def respond_to_messages
    @rubot.on :message do |data|
      if data.user != "U0RDVBPCH"
        @interactions = Interaction.all
        @interactions.each do |i|
          if i.user_input == data.text.downcase
            @rubot.web_client.chat_postMessage(
              channel: data.channel, 
              text: i.response, 
              as_user: true,
              unfurl_links: false,
              unfurl_media: false
            )
          end
        end
      end
    end
  end

  def update_user_list
    puts "Updating user list."
    get_users
    @rubot.web_client.users_list.members.each do |member|
      unless @users.any? { |person| person.slack_id == member.id }
        @user = User.new(
          user_name: member.name,
          real_name: member.profile.real_name,
          slack_id:  member.id,
          email:     member.profile.email
        )
        @user.save
      end
    end
  end

  def start_rubot
    puts "START RUBOT!!!"
    @rubot.start!
  end

  def bot_behavior
    # Need to figure out way to defend against lost connection?
    setup_client
    say_hello_on_start
    log_messages
    add_new_user
    reschedule_messages
    send_scheduled_messages
    update_user
    respond_to_messages
    update_user_list
    start_rubot
  end

end
