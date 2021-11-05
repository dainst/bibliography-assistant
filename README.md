# Bibliography Assistant

## Prerequisites

- For development with Docker: Docker and docker-compose
- For devolopment on host machine environment: Elixir, Ruby etc.

For detailed instructions for how to set up the components in local environments (`elixir`, `ruby`), see
the corresponding README.md files in [./assistant](./assistant) and [./anystyle](./anystyle).

## Start

    $ docker-compose up
    Visit localhost:4000

Or to see the logs separately, start the containers separately

    $ docker-compose up anystyle
    $ docker-compose up assistant

## Deployment

    $ docker-compose build assistant && docker-compose push assistant
    $ docker-compose build anystyle && docker-compose push anystyle

## Tests

    $ docker-compose run --entrypoint "mix test" assistant