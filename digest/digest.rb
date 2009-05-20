
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

get '/' do
  text=remote_user+"\n"
  Users.each do |user|
    text<<"  #{user[:name]}, #{user[:password]}, #{user[:encripted_password]}\n"
  end
  text
end

post '/' do
  user=params
  user[:encripted_password]=Digest::MD5.hexdigest(
    "#{user[:name]}:OpenNebula:#{user[:password]}")
  Users<<user
    
  "User #{user[:name]} added.\n"
end
  


