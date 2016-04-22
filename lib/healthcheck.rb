module Healthcheck

  def self.get_presence(client)
    presence = client.web_client.users_getPresence(user: Rails.application.config.bot_id)
    return presence.online
  end

end