require 'rubygems'
require 'rack'
require 'ipaddr'
require 'json'
require 'yaml'

Dir[File.dirname(__FILE__) + '/tasks/*.rb'].each do |file|
  require file
end

module JekyllCatcher
  class App
    def call(env)
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      handle_request
      @response.finish
    end

    def handle_request
      begin
        return @response.write "You're doing it wrong!" unless originated_from_github?
        JekyllCatcher::Task.const_get(camelize(config['jekyll_catcher_task_name'])).new(config).call
      rescue Exception => exception
        puts exception.inspect
        return @response.write "You're doing it wrong!"
      end
      @response.write "Well done, sir!"
    end

    def config
      @config ||= parse_config
    end

    def parse_config
      application_config = YAML.load_file('config.yml')[payload['name']]
      throw(:application_not_in_config) unless application_config
      throw(:repository_url_does_not_match) unless payload['url'] == application_config['url']
      throw(:task_does_not_exist) unless defined?(camelize(application_config['jekyll_catcher_task_name']))
      application_config
    end

    def camelize(name)
      name.gsub(/(?:^|_)(.)/) { $1.upcase }
    end

    def payload
      @payload ||= JSON.parse(@request.POST['payload'])['repository']
    end

    def originated_from_github?
      [
        IPAddr.new('192.30.252.0/22'),
        IPAddr.new('204.232.175.64/27')
      ].any? { |ip_range| ip_range.include?(@request.env["HTTP_X_REAL_IP"]) }
    end
  end
end

