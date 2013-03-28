require 'rubygems'
require 'rack'
require 'json'
require 'yaml'

class JekyllHookReceiver

  def call(env)
    @request = Rack::Request.new(env)
    @response = Rack::Response.new
    handle_request
    @res.finish
  end

  def handle_request
    config = YAML.load_file('config.yml')
    payload = JSON.parse(@request.POST["payload"])
    repo = payload["repository"]["name"]
    
    repo_url = payload["repository"]["url"]
    application = config["applications"][repo]

    if application["url"] == repo_url
      `cd #{application["path"]} && git pull origin master && LC_ALL='en_US.UTF-8' bundle exec jekyll --no-auto`
      @res.write "Well done, sir!"
    else
      @res.write "You're doing it wrong!"
    end
  end
end


