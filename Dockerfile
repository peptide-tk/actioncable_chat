FROM ruby:3.2.0

RUN apt-get update -qq && apt-get install -y \
  nodejs \
  npm \
  postgresql-client \
  build-essential \
  libpq-dev

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN mkdir -p tmp/pids tmp/cache log public

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
