module Healthcheck

  def self.get_presence(client)
    presence = client.web_client.users_getPresence(user: "U0RDVBPCH")
    presence.online
    puts "Presence: #{presence}"
  end

end