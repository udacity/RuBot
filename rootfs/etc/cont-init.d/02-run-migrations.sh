#!/usr/bin/with-contenv sh

set -e

pushd /app
bundle exec rake db:migrate
