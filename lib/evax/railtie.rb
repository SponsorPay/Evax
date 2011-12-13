require "rails/railtie"

class Evax
  class Railtie < Rails::Railtie
    rake_tasks do
      load "evax/tasks/evax.rake"
    end
  end
end
