class HealthchecksController < ApplicationController
  skip_before_action :authenticate_admin!

  def check
    if Healthcheck.get_presence(Rails.application.config.client) == true
      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 404
    end
  end

end