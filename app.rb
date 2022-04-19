require 'sinatra'
require "sinatra/cors"
require 'pg'
require 'json'

set :allow_origin, "*"

conn = PG.connect(dbname: "genealogy")

get '/' do
  
end

post '/add_person' do
  person = params
  id = conn.exec_params(
    "insert into people (
      name,
      lastname,
      mother_id,
      father_id
    ) values (
      $1,
      $2,
      $3,
      $4
    )
    returning id",
    [person['name'],
    person['lastname'],
    person['father_id'],
    person['mother_id']]
  ).to_a.to_json
end

post '/delete_person' do
  id = conn.exec_params(
    "DELETE FROM PEOPLE WHERE ID=$1",
    [params[:id]]
  ).to_a.to_json
end

get '/person/:id' do
  return conn.exec_params(
    "select * from people where id = $1",
    [params['id']]
  ).first.to_json
end

get '/find_people' do
  fields = [:name, :lastname, :father_id, :mother_id]
  selected_fields = fields.select {|f| params[f] != nil}
  (selected_fields.length > 0 ? conn.exec(
    "SELECT * FROM PEOPLE
      WHERE #{
        selected_fields.map {
          |f| "#{f} = '#{conn.escape_string(params[f])}'"
        }.join(" and ")
      }
    "
  ).to_a : []).to_json
end

get '/find_children/:id' do |id|
  conn.exec_params(
    "SELECT * FROM PEOPLE WHERE father_id = $1 OR mother_id = $1",
    [id]
  ).to_a.to_json
end
