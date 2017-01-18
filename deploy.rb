#!/usr/bin/env ruby

require 'json'
require 'net/http'

ENV['SERVICE'] = ENV['CIRCLE_BRANCH']
ENV['SERVICE_NAME'] = ENV['CIRCLE_BRANCH']

# Get the application ID from Conductor
def get_app_id(app_name)
  uri = URI('https://conductor-beta.udacity.com/api/v1/apps')    
  params = { :name => app_name }
  uri.query = URI.encode_www_form(params)

  req = Net::HTTP::Get.new(uri)
  req['X-GitHub-Access-Token'] = ENV['CI_GITHUB_ACCESS_TOKEN']

  http = Net::HTTP.new(uri.hostname, uri.port)
  http.use_ssl = true

  res = http.request(req)
  if !res.is_a?(Net::HTTPSuccess)
    raise "Failed to get App ID for app #{app_name}"
  end

  appJSON = JSON.parse(res.body)
  return appJSON['id']
end

# Run make deploy with modified ENV
ENV['CONDUCTOR_APP_ID'] = get_app_id(ENV['SERVICE'])
system(ENV, 'make deploy')
