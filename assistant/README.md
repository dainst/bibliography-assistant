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

    POST localhost:4000/api
    {
        "parser": "<anystyle|grobid|cermine>",
        "references": "reference-line-1\nreference-line-2"
    }
