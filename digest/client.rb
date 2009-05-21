
require 'rubygems'
require 'curb'
require 'thor'
require 'pp'

class UserAdmin < Thor
  
  def initialize(*args)
    super(*args)
    @curl=Curl::Easy.new('http://localhost:4567')
    @curl.http_auth_types=Curl::CURLAUTH_DIGEST
    @curl.userpwd='admin:hola'
    #@curl.verbose=true
  end

  desc 'list', 'lists users available'
  def list
    @curl.perform
    puts @curl.body_str
  end
  
  desc 'add USER PASSWORD', 'adds a new user'
  def add(user, password)
    @curl.http_post(
      Curl::PostField.content('name', user),
      Curl::PostField.content('password', password)
    )
    puts @curl.body_str
  end
end

UserAdmin.start

