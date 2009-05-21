
require 'rubygems'
require 'sinatra'
require 'digest/md5'
require 'sequel'
require 'pp'

DB=Sequel.sqlite("database.db")

if !DB.table_exists? :users
    DB.create_table :users do
        varchar :name
        varchar :password
        varchar :encripted_password
    end
end

Users=DB[:users]

module OpenNebulaApi
  module Auth
    module Digest
      class MD5 < Rack::Auth::Digest::MD5
        def initialize(app)
          super
          @realm = 'OpenNebula'
          @opaque = 'this is some text to mess things up'
          @passwords_hashed = true
        end
      end
    end
  end
end

configure do
    use OpenNebulaApi::Auth::Digest::MD5 do |username|
      #pp username
      #Digest::MD5.hexdigest("#{username}:OpenNebula:caracola")
      user=Users[:name => username]
      pp user
      if user
        user[:encripted_password]
      else
        false
      end
    end
end

def remote_user
  if env['REMOTE_USER']
    env['REMOTE_USER']
  else
    'NONE'
  end
end

def gen_digest(name, password)
  Digest::MD5.hexdigest("#{name}:OpenNebula:#{password}")
end

get '/' do
  text=remote_user+"\n"
  Users.each do |user|
    text<<"  #{user[:name]}, #{user[:password]}, #{user[:encripted_password]}\n"
  end
  text
end

post '/' do
  user=params
  user[:encripted_password]=gen_digest(params[:name], params[:password])
  Users<<user
    
  "User #{user[:name]} added.\n"
end

delete '/:name' do
  user=Users.filter(:name => params[:name]).first
  if user
    Users.filter(:name => params[:name]).delete
    "User #{params[:name]} deleted.\n"
  else
    "User #{params[:name]} does not exist.\n"
  end
end

put '/' do
=begin
  user=Users[:name => params[:name]]
  if user
    #user.update(
    #  :password => params[:password],
    #  :encripted_password => gen_digest(params[:user], params[:password])
    #)
    "User #{params[:name]} updated.\n"
  else
    "User #{params[:name]} does not exist.\n"
  end
=end
end
