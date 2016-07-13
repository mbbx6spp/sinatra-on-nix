require 'sinatra/base'
require 'redis'

class App < Sinatra::Base
  # Of course, what the heck am I doing? This is insane.
  # Don't do this at home kids.
  set redis: Redis.new(host: "localhost", port: 6379)

  get '/health' do
    settings.redis.ping
    "OK!"
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
