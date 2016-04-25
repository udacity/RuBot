class HealthchecksController < ApplicationController
  skip_before_action :authenticate_admin!

  def check
    status = Healthcheck.get_presence(Rails.application.config.client) ? 200 : 404
    render :nothing => true, :status => status
  end

end