module JekyllCatcherTask
  class LocalDeploy
    def initialize(config)
      @config = config
    end

    def call
      puts @config["something_random"]
    end
  end
end
