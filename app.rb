require 'sinatra'
require 'pg'
conn = PG.connect(dbname: "genealogy")

get '/' do
  'Hello world!'
end
