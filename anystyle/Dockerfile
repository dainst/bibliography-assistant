FROM ruby:2.7.4

WORKDIR /opt/src/server
COPY . /opt/src/server

RUN bundle install

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]