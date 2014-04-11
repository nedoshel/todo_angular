# rackup sync.ru -E production
require "bundler/setup"
require "yaml"
require 'faye'

Faye::WebSocket.load_adapter('thin')
#Faye.logger =  Logger.new(STDOUT)

app = Faye::RackAdapter.new(:mount => '/faye',
 :timeout => 25,
 :engine  => {
    :port  => 6379
  }
)

#app.load_config(
#  File.expand_path("../config/faye.yml", __FILE__),
#  ENV["RAILS_ENV"] || "development"
#)

run app
