require 'rubygems'
require 'rack'
require 'json'
require 'yaml'

class JekyllCatcher
  def call(env)
    @request = Rack::Request.new(env)
    @response = Rack::Response.new
    handle_request
    @response.finish
  end

  def handle_request
    config = YAML.load_file('config.yml')
    @payload = JSON.parse(@request.POST["payload"])
    repository = payload["repository"]["name"]

    @application_config = config["applications"][repository]

    @response.write "You're doing it wrong!" unless recognized_repository && originated_from_github
    # `cd #{application["path"]} && git pull origin master && LC_ALL='en_US.UTF-8' bundle exec jekyll build`
    JekyllCatcherTask.const_get(@application_config["jekyll_catcher_task_name"]).new(@application_config).call
    @response.write "Well done, sir!"
  end

  def recognized_repository
    repository_url = @payload["repository"]["url"]
    @application_config["url"] == repository_url
  end

  def originated_from_github
    [
      IPAddr.new('192.30.252.0/22'),
      IPAddr.new('204.232.175.64/27')
    ].any? { |ip_range| ip_range.include?(@request.ip) }
  end
end

