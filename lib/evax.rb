require "yaml"
require "uglifier"
require "watchr"

require_relative "evax/version"
require_relative "evax/css_minifier"
require_relative "evax/logger"

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
    build_js  if js_configured?
    build_css if css_configured?
  end

  def watch
    script = Watchr::Script.new
    script.watch( asset_files_regex(:javascripts) ) {|asset| build_js( js_groups_for( asset[0] ) ) } if js_configured?
    script.watch( asset_files_regex(:stylesheets) ) {|asset| build_css( css_groups_for( asset[0] ) ) } if css_configured?
    Watchr::Controller.new( script, Watchr.handler.new ).run
  end

  def build_js( group_names=[] )
    groups = config["javascripts"]
    groups.select!{|k, v| group_names.include? k } if group_names.any?

    groups.each_key do |group_name|
      result_string = join( :javascripts, group_name )
      result_string = Evax.compress_js( result_string ) if config["compress"]

      write_output( "#{group_name}.js", result_string )
    end
  end

  def build_css( group_names=[] )
    groups = config["stylesheets"]
    groups.select!{|k, v| group_names.include? k } if group_names.any?

    groups.each_key do |group_name|
      result_string = join( :stylesheets, group_name )
      result_string = Evax.compress_css( result_string ) if config["compress"]

      write_output( "#{group_name}.css", result_string )
    end
  end

  def write_output( file_name, string )
    path      = File.expand_path( File.join( relative_path, config['output_path'] ) )
    file_path = File.join( path, file_name )

    Evax::Logger.log "Writing file: #{file_path}"

    FileUtils.mkdir_p path
    File.open( file_path, 'w' ) { |f| f.write string }
  end

  def self.compress_js( js_string )
    opts = { :copyright => false }
    Uglifier.compile( js_string, opts )
  end

  def self.compress_css( css_string )
    Evax::CssMinifier.build( css_string )
  end

  private

  def js_configured?
    !config["javascripts"].nil?
  end

  def css_configured?
    !config["stylesheets"].nil?
  end

  def asset_files_regex(type)
    config[type.to_s].values.flatten.uniq.map {|path| Regexp.quote( path ) }.join( "|" )
  end

  def js_groups_for( file )
    filter_groups_by_file( :javascripts, file )
  end

  def css_groups_for( file )
    filter_groups_by_file( :stylesheets, file )
  end

  def filter_groups_by_file(type, file)
    config[type.to_s].select {|k, v| v.include? file }.keys
  end

end
