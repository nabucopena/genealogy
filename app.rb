require 'sinatra'
require 'pg'
conn = PG.connect(dbname: "genealogy")

get '/' do
  erb :index
end

post '/add_person' do
  person = params
  conn.exec_params(
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
    )",
    [person['name'],
    person['lastname'],
    person['father_id'],
    person['mother_id']]
  )
  redirect('/people')
end

get '/people' do
  people = conn.exec_params(
    "select * from people"
  ).to_a
  erb :show_people, :locals => {:people => people}
end