FROM ruby:3.0.0

WORKDIR /app
COPY Gemfile* ./
RUN bundle install

COPY consumer.rb .

CMD ["bundle", "exec", "ruby", "consumer.rb"]
