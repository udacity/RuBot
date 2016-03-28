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

  def self.blast(client)
    User.all.each do |user|
      if user.email
        unless user.channel_id
          user.channel_id = client.web_client.im_open(user: user.slack_id).channel.id
          user.save
          @blast = Blast.last
          send_blast(user.channel_id, @blast, client)
          sleep(1)
        end
        # @blast = Blast.last
        # send_blast(user.channel_id, @blast, client)
        # sleep(1)
      end
    end
  end

end
