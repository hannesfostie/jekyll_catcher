jekyll_catcher
==============

A jekyll-targeted GitHub webhook server

Configuration
=============

Copy `config.yml.example` into `config.yml` and insert all the variables that are already included. You can add multiple applications and add your own variables per application for use in your scripts.

Deploy scripts
==============

After specifying the name of your script in the `config.yml` file, it's time to write the script to use to deploy your Jekyll.

Create a new file in the `tasks/` folder based off of one of the examples in `tasks/example`.

In your deploy task you have access to the `@config` variable which contains all the variables from the `config.yml` file for this specific application so you can safely store server information in there, assuming you include it in your `.gitignore`.
