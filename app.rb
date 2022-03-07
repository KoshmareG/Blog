require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "userposts.db"}

class Userpost < ActiveRecord::Base
  has_many :comments

  validates :name, presence: true
  validates :post, presence: true
end

class Comment < ActiveRecord::Base
  belongs_to :userpost

  validates :commentname, presence: true
  validates :usercomment, presence: true
end

get '/' do
  @userpost = Userpost.order 'id desc'
  erb :index
end

get '/hotposts' do
  @userpost = Userpost.order 'id desc'
  erb :hotposts
end

get '/newpost' do
  @userpost = Userpost.new
  erb :newpost
end

post '/newpost' do
  @userpost = Userpost.new params[:userpost]

  if @userpost.save
    erb 'Ваш пост отправлен'
  else
    @error = @userpost.errors.full_messages.first
    erb :newpost
  end
end

get '/post/:post_id' do
  @post_id = params[:post_id]
  @userpost = Userpost.find(@post_id)
  @comments = Comment.where 'userpost_id = ?', [@post_id]
  erb :post
end

post '/post/:post_id' do
  @post_id = params[:post_id]
  @comment = Comment.new params[:comment].merge(userpost_id: @post_id)
  @comment.save
  redirect to ('/post/' + @post_id)
end
