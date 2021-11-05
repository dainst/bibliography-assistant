FROM elixir:latest

COPY . /opt/src/assistant

WORKDIR "/opt/src/assistant"
RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "vim"]
RUN ["wget", "https://deb.nodesource.com/setup_14.x"]
RUN ["chmod", "+x", "setup_14.x"]
RUN ["./setup_14.x"]
RUN ["apt-get", "install", "-y", "nodejs"]

WORKDIR "/opt/src/assistant"
RUN ["mix", "local.hex", "--force"]
RUN ["mix", "local.rebar", "--force"]
RUN ["mix", "deps.get"]
RUN ["mix", "deps.compile"]

ENTRYPOINT ["mix", "phx.server"]