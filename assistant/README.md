# Assistant

## Prerequisites

* Elixir

## Run

    $ cd assistant
    $ npm i --prefix ./assets
    $ mix deps.get
    $ mix phx.server
    Visit localhost:4000

## API

POST your citations as plain text to `localhost:4000/api` and receive a JSON-result. 
Line separators within the text are used to identify separate entries.

## Tests

    $ mix test