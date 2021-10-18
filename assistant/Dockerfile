FROM elixir:latest

COPY . /opt/src/assistant

WORKDIR "/opt/src/assistant"

RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "vim"]

RUN ["mix", "local.hex", "--force"]
RUN ["mix", "local.rebar", "--force"]
RUN ["mix", "deps.get"]
RUN ["mix", "deps.compile"]

ENTRYPOINT ["mix", "phx.server"]