FROM ruby:3.4.5-slim

WORKDIR /app

COPY Gemfile* .

RUN bundle install

COPY . .

CMD ["./bin/run"]
