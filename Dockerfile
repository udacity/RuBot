FROM udacity/ruby:2.2.4

RUN apk-install --no-cache \ 
    build-base \
    gcc \
    libxslt-dev \
    libxml2-dev \
    postgresql-dev \
    make 


RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install --jobs 20 --retry 5 --without development test

ADD . /app

CMD ["bundle", "exec", "rails", "-s"]
