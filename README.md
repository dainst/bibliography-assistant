# Bibliography Assistant

## Getting started

For detailed instructions for how to set up the components in local environments (`elixir`, `ruby`), see
the corresponding README.md files in [./assistant](./assistant) and [./anystyle](./anystyle).

For development with Docker, see the following section

### Getting started with Docker

#### Prerequisites

- `Docker` and `docker-compose`

#### Prepare

    [1] $ docker-compose run --entrypoint "npm install --prefix ./assets" assistant

#### Start

Run

    $ docker-compose up

Then visit `localhost:4000`

Or to see the logs separately, start the containers separately

    $ docker-compose up anystyle
    $ docker-compose up assistant

## Tests

    $ docker-compose run --entrypoint "mix test" assistant

## Deployment

Make sure, `[1]` happened. Then

    $ docker-compose build assistant && docker-compose push assistant
    $ docker-compose build anystyle && docker-compose push anystyle
