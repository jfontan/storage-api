
require 'rubygems'
require 'curb'

c=Curl::Easy.new('http://localhost:4567')
c.http_auth_types=Curl::CURLAUTH_DIGEST
c.userpwd='admin:hola'
c.verbose=true

case ARGV[0]
when 'list'
  c.perform
  puts c.body_str
  
when 'add'
  c.http_post(
    Curl::PostField.content('name', ARGV[1]),
    Curl::PostField.content('password', ARGV[2])
  )
  puts c.body_str
end



