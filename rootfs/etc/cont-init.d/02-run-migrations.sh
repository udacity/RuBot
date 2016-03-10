#!/usr/bin/with-contenv sh

set -e

cd /app && bundle exec rake db:migrate
