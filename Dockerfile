FROM ruby:2.7.6
RUN apt update \
  && apt install -y cron \
  && rm -rf /var/lib/apt/lists/* \
  && gem install bundler:2.3.7

ENV APP_PATH=/opt/likes4satsbot
ENV CRON_LOG_PATH=/var/log/cron.log

WORKDIR $APP_PATH

COPY . $APP_PATH/

RUN bundle check || bundle install

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["docker-start", "start-cron", "tail-cron-log"]