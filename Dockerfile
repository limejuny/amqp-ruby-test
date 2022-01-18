FROM ruby:3.0.0

RUN apt update && apt -y install supervisor
COPY supervisord.conf /etc/supervisord.conf

WORKDIR /app
COPY Gemfile* ./
RUN bundle install

COPY consumer.rb .

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
