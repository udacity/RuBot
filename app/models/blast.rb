class Blast < ActiveRecord::Base

  def self.send_blast(channel_id, blast, client)
    client.web_client.chat_postMessage(
      channel: channel_id, 
      text: blast.text,
      as_user: true,
      unfurl_links: false,
      unfurl_media: false
      )
  end

  def self.setup_blast(client, user, blast)
    puts "SENDING BLAST FOR USER #{user.user_name}"
    send_blast(user.channel_id, blast, client)
  end

  def self.schedule_blasts(client)
    blast = Blast.last
    time = Time.now + 5
    User.all.each do |user| 
      puts "SCHEDULING BLAST FOR USER #{user.user_name} AT #{time}"
      if user.channel_id
        time += 1
        s = Rufus::Scheduler.new
        s.at time do
          send_blast(user.channel_id, blast, client)
          puts "Sent BLAST FOR USER #{user.user_name} AT #{Time.now}"
        end
      end
    end
  end
end
