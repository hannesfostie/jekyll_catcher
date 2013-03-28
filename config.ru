require 'rubygems'
require 'rack'
require './jekyll_hook_receiver.rb'
run JekyllHookReceiver.new
