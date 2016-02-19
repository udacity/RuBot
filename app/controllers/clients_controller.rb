class ClientsController < ApplicationController

  # GET /clients/new
  def new
    @client = Client.new
    @client.setup_client
    @client.say_hello_on_start
    @client.log_messages
    @client.start_rubot
  end

end
