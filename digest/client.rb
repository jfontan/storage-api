
require 'rubygems'
require 'curb'
require 'thor'
require 'pp'

class UserAdmin < Thor
  
  def initialize(*args)
    super(*args)
    @curl=Curl::Easy.new('http://localhost:4567/')
    @curl.http_auth_types=Curl::CURLAUTH_DIGEST
    @curl.userpwd='admin:hola'
    @curl.verbose=true
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
  
  desc 'delete USER', 'deletes a user'
  def delete(user)
    @curl.url=@curl.url+user
    @curl.http_delete()
    puts @curl.body_str
  end

  desc 'passwd USER PASSWORD', 'changes the password of a user'
  def passwd(user, password)
    @curl.url=@curl.url+user
    @curl.http_put(
      Curl::PostField.content('password', password)
    )
    puts @curl.body_str
  end

end

UserAdmin.start

