# Anystyle Sinatra Wrapper

## Start

    $ bundle install
    $ ruby server.rb
    
## API

POST your citations as plain text to `localhost:4567` and receive a JSON-result. 
Line separators within the text are used to identify separate entries.

## Customization

To create an empty model which can be later used for training use

    $ ruby fresh.rb

To copy the AnyStyle's default model to the working directory use

    $ ruby default.rb
