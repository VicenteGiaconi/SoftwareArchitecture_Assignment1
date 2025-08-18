FROM ruby:3.4.5

RUN apt-get update -qq && apt-get install -y postgresql-client

WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Instala las gemas
RUN bundle install

COPY . /myapp

EXPOSE 3000