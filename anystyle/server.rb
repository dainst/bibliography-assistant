require 'sinatra'
require 'anystyle'
require 'pp'

post '/' do
    body = request.body.read
    pp body.force_encoding('utf-8').encode
    results = AnyStyle.parse body
    content_type :json
    { results: results }.to_json
end