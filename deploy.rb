#!/usr/bin/env ruby
# A simple script for namespacing configs in CircleCI

ENV['SERVICE'] = ENV['CIRCLE_BRANCH']
ENV['SERVICE_NAME'] = ENV['CIRCLE_BRANCH']

ENV.each do |k,v| 
  if k.start_with?(ENV['CIRCLE_BRANCH'].upcase)
    key = k.split('_').slice(1..-1).join('_')
    ENV[key] = v
    puts key
  end
end

# Run make deploy with modified ENV
system(ENV, 'make deploy')
