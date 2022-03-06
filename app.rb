require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "userposts.db"}

class Userpost < ActiveRecord::Base
  has_many :comments
end

get '/' do
  erb :index
end

get '/hotposts' do
  erb :hotposts
end

get '/newpost' do
  @userpost = Userpost.new
  erb :newpost
end

post '/newpost' do
  @userpost = Userpost.new params[:userpost]
  @userpost.save
  erb 'Ваш пост отправлен'
end

get '/post/:post_id' do
  erb :post
end

post '/post/:post_id' do
  post_id = params[:post_id]
  
end
