require "yaml"
require "watchr"

require_relative "evax/version"
require_relative "evax/logger"
require_relative "evax/asset_type"

class Evax
  attr_reader :config_file, :relative_path

  def initialize( config_file = "config/assets.yml", relative_path = "public/assets" )
    @config_file   = File.expand_path( config_file )
    @relative_path = File.expand_path( relative_path )

    Evax::Logger.log "Config File: #{self.config_file}"
    Evax::Logger.log "Relative Path: #{self.relative_path}"
  end

  def run_once
    build
  end

  def run_as_daemon
    watch
  end

  def config
    default_opts = { "compress" => true }
    default_opts.merge(YAML::load_file( @config_file ))
  end

  def join( type_name, group_name )
    config[type_name.to_s][group_name].map do |file_path|
      File.read( File.join( relative_path, file_path ) )
    end.join( "\n" )
  end

  def build
    AssetType.all.each {|type| build_assets( type ) if type_configured?( type.name ) }
  end

  def watch
    script = Watchr::Script.new

    AssetType.all.each do |type|
      if type_configured?( type.name )
        script.watch( asset_files_regex( type.name ) ) do |asset|
          build_assets( type, filter_groups_by_file( type.name, asset[0] ) )
        end
      end
    end

    Watchr::Controller.new( script, Watchr.handler.new ).run
  end

  def build_js( group_names=[] )
    build_assets( AssetType::Javascript, group_names )
  end

  def build_css( group_names=[] )
    build_assets( AssetType::Stylesheet, group_names )
  end

  def write_output( file_name, string )
    path      = File.expand_path( File.join( relative_path, config['output_path'] ) )
    file_path = File.join( path, file_name )

    Evax::Logger.log "Writing file: #{file_path}"

    FileUtils.mkdir_p path
    File.open( file_path, 'w' ) { |f| f.write string }
  end

  def self.compress_js( js_string )
    AssetType::Javascript.compress( js_string )
  end

  def self.compress_css( css_string )
    AssetType::Stylesheet.compress( css_string )
  end

  private

  def build_assets( asset_type, group_names=[] )
    groups = config[asset_type.name]
    groups.select! {|k, v| group_names.include? k } if group_names.any?

    groups.each_key do |group_name|
      result_string = join( asset_type.name, group_name )
      result_string = asset_type.compress( result_string ) if config["compress"]

      write_output( "#{group_name}.#{asset_type.file_extension}", result_string )
    end
  end

  def type_configured?( type_name )
    !config[type_name].nil?
  end

  def asset_files_regex( type_name )
    config[type_name].values.flatten.uniq.map {|path| Regexp.quote( path ) }.join( "|" )
  end

  def filter_groups_by_file( type_name, file )
    config[type_name].select {|k, v| v.include? file }.keys
  end

end
