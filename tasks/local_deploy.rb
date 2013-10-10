module JekyllCatcher
  module Task
    class LocalDeploy
      def initialize(config)
        @config = config
      end

      def call
        run "cd #{@config['path']} && LC_ALL='en_US.UTF-8' bundle exec sass --update _sass:css -f"
        run "cd #{@config['path']} && LC_ALL='en_US.UTF-8' bundle exec jekyll build --no-auto"
      end
    end
  end
end

