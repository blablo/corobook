FROM ruby:2.2.4
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev git nodejs

RUN mkdir /corobook

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

COPY . /corobook
WORKDIR /corobook

RUN mkdir -p /tmp/sockets 
RUN mkdir -p /tmp/pids
RUN touch /tmp/sockets/puma.sock
RUN touch /tmp/pids/puma.pid

RUN chmod 755 /corobook/run.sh

EXPOSE 3000

CMD /corobook/run.sh
