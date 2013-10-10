require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
$:.unshift File.dirname(File.expand_path('../', __FILE__))
require 'jekyll_catcher'

describe JekyllCatcher do
  before do
    @app = JekyllCatcher::App.new
    @github_payload = JSON.parse(File.read(File.join(File.expand_path('../fixtures', __FILE__), 'github_payload.json')))
  end

  it 'replies with a fail message on GET' do
    @app.stub :originated_from_github?, true do
      request = Rack::MockRequest.new(@app)
      response = request.get('/')
      response.status.must_equal 200
      response.body.must_match(/doing\ it\ wrong/i)
    end
  end

  it 'replies with a fail message on POST without payload' do
    @app.stub :originated_from_github?, true do
      request = Rack::MockRequest.new(@app)
      response = request.post('/', {})
      response.status.must_equal 200
      response.body.must_match(/doing\ it\ wrong/i)
    end
  end

  it 'replies with a fail message on POST when not originating from GitHub' do
    skip 'test'
  end

  it 'triggers a new JekyllCatcherTask task with the app config as an argument' do
    skip 'test'
  end
end
