#!/usr/bin/env ruby

ENV['SERVICE'] = ENV['CIRCLE_BRANCH']
ENV['SERVICE_NAME'] = ENV['CIRCLE_BRANCH']

ENV.each do |k,v| 
  if k.start_with?(ENV['CIRCLE_BRANCH'].upcase)
    _, key = k.split('_')
    ENV[key] = v
    `make deploy`
  end
end
