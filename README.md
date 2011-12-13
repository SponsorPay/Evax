# Evax Assets Compressor

![Evax compressor logo](http://farm8.staticflickr.com/7166/6505430865_1f9f232e8c_o_d.png)
*Evax compressor make you feel lighter*

Evax is a simple asset packaging library for Ruby, providing JavaScript/CSS concatenation and compression using UglifyJS and a really simple regex based CSS compressor. Just because enough is enough.

The idea behind it is to have a really **simple library to compress your assets** in the simplest way without any weird dependency (who said Java?). There are nice assets packaging systems out there but they have too many options for some cases. Sometimes, you just want to play with a pet project.

Create a YAML file describing assets, Evax will take it and compress the javascript and stylesheets files to the *output directory* of your choice. Done.

## Instalation

     gem install evax

## Usage

### assets.yml

     output_path: tmp/

     javascripts:
       js_package_one:
         - test/fixtures/javascripts/one.js
         - test/fixtures/javascripts/two.js
         - test/fixtures/javascripts/three.js
       js_package_two:
         - test/fixtures/javascripts/four.js

     stylesheets:
       css_package_one:
         - test/fixtures/stylesheets/one.css
         - test/fixtures/stylesheets/two.css
       css_package_two:
         - test/fixtures/stylesheets/three.css
         - test/fixtures/stylesheets/four.css

### Command Line

      evax /path/to/assets.yml /relative/path

### Rails

Add **evax** to your Gemfile:

    gem 'evax'

Create a Rake task for running it, e.g.:

    namespace :evax do
      desc 'Build assets'
      task :build do
        ASSETS_PATH   = "#{Rails.root}/config/assets.yml"
        RELATIVE_PATH = Rails.root
        Evax.new( ASSETS_PATH, RELATIVE_PATH ).build
      end
    end
