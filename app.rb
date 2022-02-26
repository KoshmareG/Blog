require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_database
  @db = SQLite3::Database.new 'Usersposts.db'
  @db.results_as_hash = true
  return @db
end

def form_validation error_hash
  error = error_hash.select{|key, value| params[key].empty?}.values.join(", ")
end

def comment_init post_id
  posts = @db.execute 'select * from Posts where id = ?', [post_id]
  @row = posts[0]
  @comments = @db.execute 'select * from Comments where post_id = ? order by id', [post_id]
end

before do
  init_database
end

configure do
  init_database
  @db.execute 'create table if not exists "Posts" ("id" integer primary key autoincrement, "username" text, "postdate" date, "post" text)'

  @db.execute 'create table if not exists "Comments" ("id" integer primary key autoincrement, "comdate" date, "commentusername" text, "comment" text, "post_id" integer)'
end

get '/' do
  @posts = @db.execute 'select * from Posts order by id desc'
  erb :index
end

get '/newpost' do
  erb :newpost
end

post '/newpost' do
  @newuserpost = params[:newuserpost]
  @username = params[:username]

  error_hash = {:username => 'имя', :newuserpost => 'пост'}

  error = form_validation error_hash

  if error == ''
    @db.execute 'insert into Posts (postdate, username, post) values (datetime(), ?, ?)', [@username, @newuserpost]
    redirect to '/'
  else
    @error = "Заполните поля: " + error
    return erb :newpost
  end
end

get '/post/:post_id' do
  post_id = params[:post_id]

  comment_init post_id

  erb :post
end

post '/post/:post_id' do
  post_id = params[:post_id]
  @commentusername = params[:commentusername]
  @newcomment = params[:newcomment]

  error_hash = {:commentusername => 'имя', :newcomment => 'комментарий'}

  error = form_validation error_hash

  if error == ''
    @db.execute 'insert into Comments (comdate, commentusername, comment, post_id) values (datetime(), ?, ?, ?)', [@commentusername, @newcomment, post_id]
    redirect to ('/post/' + post_id)
  else
    comment_init post_id
    @error = "Заполните поля: " + error
    return erb :post
  end
end
