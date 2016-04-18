FROM udacity/ruby:2.2.4

RUN apk-install \ 
    build-base \
    gcc \
    libxslt-dev \
    libxml2-dev \
    postgresql-dev \
    make \
    nodejs

RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install --jobs 20 --retry 5 --without development test

COPY rootfs/ /

ADD . /app

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
