require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_database
  @db = SQLite3::Database.new 'Usersposts.db'
  @db.results_as_hash = true
  return @db
end

before do
  init_database
end

configure do
  init_database
  @db.execute 'create table if not exists "Posts" ("id" integer primary key autoincrement, "postdate" date, "post" text)'
end

get '/' do
  @posts = @db.execute 'select * from Posts order by id desc'
  erb :index
end

get '/newpost' do
  erb :newpost
end

post '/newpost' do
  newuserpost = params[:newuserpost]

  if newuserpost.size <= 0
    @error = 'Введите текст поста'
    return erb :newpost
  else
    @db.execute 'insert into Posts (postdate, post) values (datetime(), ?)', [newuserpost]
    erb 'Ваш пост отправлен!'
  end
end