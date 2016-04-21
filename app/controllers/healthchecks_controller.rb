class HealthchecksController < ApplicationController
  skip_before_action :authenticate_admin!

  def check
    puts "Start Healthcheck"
    status = Healthcheck.get_presence(Rails.application.config.client) ? 200 : 404
    puts "Status: #{status}"
    render :nothing => true, :status => status
  end

end