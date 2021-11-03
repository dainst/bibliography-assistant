# Bibliography Assistant

## Prerequisites

- Docker and docker-compose

## Start

    $ docker-compose up
    Visit localhost:4000

Or to see the logs separately, start the containers separately

    $ docker-compose up anystyle
    $ docker-compose up assistant

For instructions for how to run the components in local environments (`elixir`, `ruby`), see
the corresponding README.md files in [./assistant](./assistant) and [./anystyle](./anystyle).

## Deployment

    $ docker-compose build assistant
    $ docker-compose push assistant
    $ docker-compose build anystyle
    $ docker-compose push anystyle
