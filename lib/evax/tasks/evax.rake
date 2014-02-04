namespace :evax do

  desc "Build assets with Evax"
  task :build, :config_path, :output_path do |task, args|
    config_file_path = args[:config_path] || Evax::DEFAULT_CONFIG_FILE
    relative_path    = args[:output_path] || Evax::DEFAULT_RELATIVE_PATH

    Evax.new(config_file_path, relative_path).build
  end

end
