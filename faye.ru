# rackup sync.ru -E production
# require "bundler/setup"
# require "yaml"
require 'faye'

Faye::WebSocket.load_adapter('thin')
#Faye.logger =  Logger.new(STDOUT)

app = Faye::RackAdapter.new(
  :mount => '/faye',
  :timeout => 25
)

run app
