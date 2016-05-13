class Client < ActiveRecord::Base
  require 'pp'
  include SegmentAnalytics
  include ClientUser

  def setup_client
    puts "setup rubot!"
    @rubot = Slack::RealTime::Client.new(websocket_ping: 40)
    # Override the CA_FILE and CA_PATH in the embedded web client if they are set in the environment
    if ENV['CA_FILE'] and ENV['CA_PATH']    
        web_client = Slack::Web::Client.new(ca_file: ENV['CA_FILE'], ca_path: ENV['CA_PATH'], websocket_ping: 40)
        @rubot.web_client = web_client
    end
    @rubot
  end

  def say_hello_on_start(client)
    client.on :hello do 
      puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
    end
  end

  def get_bot_user_id(client)
    client.on :hello do
      get_users
      puts "Bot name: #{client.self.name}"
      bot = @users.select { |bot| bot.user_name == client.self.name }.first
      #Set global to be used for health check and "respond_to_messages"
      Rails.application.config.bot_id = bot.slack_id
      puts "Bot ID: #{Rails.application.config.bot_id}"
    end
  end

  def track_messages(client)
    client.on :message do |data|
      user = User.where(slack_id: data.user).first
      identify(user)
      track_message(data, user)
    end
  end

  def send_message(channel_id, text, client)
    client.web_client.chat_postMessage(
      channel: channel_id, 
      text: text,
      as_user: true,
      unfurl_links: false,
      unfurl_media: false
      )
  end

  def create_log(user, message)
    #message_number is "delay" in seconds.
    delivery_time = Time.now + message.message_number
    @log = Log.new(
      channel_id: user.channel_id,
      message_id: message.id,
      delivery_time: delivery_time
    )
    @log.save
  end

  def send_scheduled_messages(client)
    client.on :team_join do |data|
      sleep(2)
      set_user(data)
      @messages = Message.all.sort
      @messages.each do |message|
        create_log(@user, message)
        s = Rufus::Scheduler.new(:max_work_threads => 200)
        s.in message.delay do
          ActiveRecord::Base.connection_pool.with_connection do 
            send_message(@user.channel_id, message.text, client)
            track_scheduled_message(@user, message.id, message.text)
            message.reach += 1
            message.save
            Log.where(message_id: message.id).first.delete
          end
        end
      end
    end
  end

  def reschedule_messages(client)
    Log.all.each do |log|
      if log.delivery_time > Time.now
        s = Rufus::Scheduler.new(:max_work_threads => 200)
        s.at log.delivery_time do
          ActiveRecord::Base.connection_pool.with_connection do
            message = Message.find(log.message_id) 
            send_message(log.channel_id, message.text, client)
            track_rescheduled_message(log, log.message_id, message.text)
            message.reach += 1
            message.save
            log.delete
          end
        end
      end
    end
  end

  def respond_to_messages(client)
    client.on :message do |data|
      #make sure bot only responds to other users and only in DM channels
      if data.user != Rails.application.config.bot_id && data.channel[0] == "D" && data.text
        if interaction = Interaction.where(user_input: data.text.downcase).first
          send_message(data.channel, interaction.response, client)
          track_interactions(data, interaction.id, interaction.user_input, interaction.response)
          interaction.hits += 1
          interaction.save
        else
          #if no matching interaction, send from a standard response set in "application.rb"
          send_message(data.channel, Rails.application.config.standard_responses.sample, client)
          track_interactions(data, 0, "no trigger", "standard_response")
        end
      end
    end
  end

  def start_rubot(client)
    puts "START RUBOT!!!"
    client.start!
  end

  def kill_client_for_testing(client)
    s = Rufus::Scheduler.new
    s.in '15s' do
      # puts "Client before #{client.web_client.channels_list.channels}"
      puts "killing connection"
      client.stop!
      # sleep(15)
      # puts "Client after #{client.web_client.channels_list.channels}"
    end
  end

  def restart_client_if_connection_lost(client)
    # kill_client_for_testing(client)
    client.on :close do |data|
      puts 'Connection has been disconnected. Restarting.'
      Rails.application.config.client = setup_client
      restart_bot(Rails.application.config.client)
    end
  end

  # This method is just for fun.
  def argue_with_slackbot(client)
    client.on :message do |data|
      if data.user == "USLACKBOT"
        client.web_client.chat_postMessage(
          channel: data.channel, 
          text: "slackbot... what a dweeb.", 
          as_user: true,
          unfurl_links: false,
          unfurl_media: false
        )
      end
    end
  end

  #Grabs the channel data from slack's api 
  #to be used by "channel_id_to_name" method
  def set_channel_info(client)
    s = Rufus::Scheduler.new(:max_work_threads => 200)
    #Wait 5s so that the client is setup before trying to run.
    s.in '5s' do
      @@channel_list = client.web_client.channels_list.channels
    end
    s = Rufus::Scheduler.new(:max_work_threads => 200)
    s.every '15m' do
      @@channel_list = client.web_client.channels_list.channels || @@channel_list
    end
  end

  #Set channel names for "track_message" method in segment_analytics.rb
  def channel_id_to_name(data)
    channel = nil
    if @@channel_list
      channel = @@channel_list.select {|channel| channel.id == data.channel}.first
    end
    channel_name = channel != nil ? channel.name : "nil"
  end

  def initialize_bot(client)
    say_hello_on_start(client)
    set_channel_info(client)
    track_messages(client)
    update_user_list(client)
    set_channel_id(client)
    get_bot_user_id(client)
    add_new_user(client)
    reschedule_messages(client)
    send_scheduled_messages(client)
    update_user(client)
    respond_to_messages(client)
    # argue_with_slackbot(client)
    restart_client_if_connection_lost(client)
    start_rubot(client)
  end

  def restart_bot(client)
    say_hello_on_start(client)
    track_messages(client)
    add_new_user(client)
    send_scheduled_messages(client)
    update_user(client)
    respond_to_messages(client)
    restart_client_if_connection_lost(client)
    start_rubot(client)
  end

end
