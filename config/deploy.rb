set :application, "default"
set :repository,  "git@gitlab.bantephant.be:hannesfostie/hook.git"
set :branch,      "master"

role :web, "hook@web-001.maloik.co"
role :app, "hook@web-001.maloik.co"
