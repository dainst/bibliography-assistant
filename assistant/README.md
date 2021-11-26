# Assistant

## Prerequisites

* Elixir
* NPM

## Prepare

Run

    $ npm i --prefix ./assets
    $ mix deps.get

## Start
    
Run

    $ mix phx.server
    
Then visit `localhost:4000`

## API

POST your citations as plain text to `localhost:4000/api` and receive a JSON-result. 
Line separators within the text are used to identify separate entries. Anystyle is used
as the default parser here. If GROBID is available, it can be used with `localhost:4000/api?parser=grobid`.

## Tests

    $ mix test