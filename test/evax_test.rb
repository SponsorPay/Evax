require_relative "test_helper"

class EvaxTest < Test::Unit::TestCase
  def setup
    Evax::Logger.stubs( :log )
  end

  def test_initialize
    evax = Evax.new( "/wadus", "/tradus" )
    assert_match( "/wadus", evax.config_file )
    assert_match( "/tradus", evax.relative_path )
  end

  def test_read_config_file
    evax = Evax.new( "#{FIXTURES}/assets.yml")
    assert_equal( "tmp/", evax.config["output_path"] )
    assert_equal( true, evax.config["compress"] )
    assert_equal( 2, evax.config["javascripts"].size )
  end

  def test_read_config_file_compress_on
    evax = Evax.new( "#{FIXTURES}/assets_compress_on.yml")
    assert_equal( true, evax.config["compress"] )
  end

  def test_read_config_file_compress_off
    evax = Evax.new( "#{FIXTURES}/assets_compress_off.yml")
    assert_equal( false, evax.config["compress"] )
  end

  def test_join
    evax = Evax.new( "#{FIXTURES}/assets.yml", "/wadus" )

    [
      "/wadus/test/fixtures/javascripts/one.js",
      "/wadus/test/fixtures/javascripts/two.js",
      "/wadus/test/fixtures/javascripts/three.js"
    ].each do |path|
      File.expects( :read ).with( path )
    end

    evax.join( :javascripts, "js_one" )
  end

  def test_join_js_files
    evax = Evax.new( "#{FIXTURES}/assets.yml", "#{File.dirname(__FILE__)}/.." )
    assert_equal File.read("#{FIXTURES}/js_one.js"), evax.join( :javascripts, "js_one" )
  end

  def test_join_css_files
    evax = Evax.new( "#{FIXTURES}/assets.yml", "#{File.dirname(__FILE__)}/.." )

    assert_equal File.read("#{FIXTURES}/css_one.css"), evax.join( :stylesheets, "css_one" )
  end

  def test_compress_js
    result = Evax.compress_js( File.read( "#{FIXTURES}/js_one.js" ) )

    assert_equal( File.read( "#{FIXTURES}/js_one.compress.js" ), result)
  end

  def test_compress_css
    result = Evax.compress_css( File.read( "#{FIXTURES}/css_one.css" ) )

    assert_equal( File.read( "#{FIXTURES}/css_one.compress.css" ), result)
  end

  def test_write_output
    Dir.mktmpdir do |dir|
      evax = Evax.new( "#{FIXTURES}/assets.yml", dir )
      evax.write_output( "wadus.txt", "write this!" )

      assert_equal( "write this!", File.read( "#{dir}/tmp/wadus.txt" ) )
    end
  end

  def test_build_js
    evax = Evax.new( "#{FIXTURES}/assets.yml", "#{File.dirname(__FILE__)}/.." )
    evax.expects( :write_output ).with( "js_one.js", File.read( "#{FIXTURES}/js_one.compress.js" ) )
    evax.expects( :write_output ).with( "js_two.js", File.read( "#{FIXTURES}/js_two.compress.js" ) )

    evax.build_js
  end

  def test_build_js_compress_off
    evax = Evax.new( "#{FIXTURES}/assets_compress_off.yml", "#{File.dirname(__FILE__)}/.." )
    Evax.expects( :compress_js ).never
    evax.expects( :write_output ).with( "js_one.js", File.read( "#{FIXTURES}/js_one.compress_off.js" ) )
    evax.expects( :write_output ).with( "js_two.js", File.read( "#{FIXTURES}/js_two.compress_off.js" ) )

    evax.build_js
  end

  def test_build_css
    evax = Evax.new( "#{FIXTURES}/assets.yml", "#{File.dirname(__FILE__)}/.." )
    evax.expects( :write_output ).with( "css_one.css", File.read( "#{FIXTURES}/css_one.compress.css" ) )
    evax.expects( :write_output ).with( "css_two.css", File.read( "#{FIXTURES}/css_two.compress.css" ) )

    evax.build_css
  end

  def test_build_css_off
    evax = Evax.new( "#{FIXTURES}/assets_compress_off.yml", "#{File.dirname(__FILE__)}/.." )
    Evax.expects( :compress_css ).never
    evax.expects( :write_output ).with( "css_one.css", File.read( "#{FIXTURES}/css_one.compress_off.css" ) )
    evax.expects( :write_output ).with( "css_two.css", File.read( "#{FIXTURES}/css_two.compress_off.css" ) )

    evax.build_css
  end

  def test_build_only_css_if_js_not_configured
    evax = Evax.new( "#{FIXTURES}/assets_without_javascripts.yml", "#{File.dirname(__FILE__)}/.." )

    evax.expects( :write_output ).with( "css_one.css", File.read( "#{FIXTURES}/css_one.compress.css" ) )
    evax.expects( :write_output ).with( "css_two.css", File.read( "#{FIXTURES}/css_two.compress.css" ) )

    evax.build
  end

  def test_build_only_js_if_css_not_configured
    evax = Evax.new( "#{FIXTURES}/assets_without_stylesheets.yml", "#{File.dirname(__FILE__)}/.." )

    evax.expects( :write_output ).with( "js_one.js", File.read( "#{FIXTURES}/js_one.compress.js" ) )
    evax.expects( :write_output ).with( "js_two.js", File.read( "#{FIXTURES}/js_two.compress.js" ) )

    evax.build
  end

  def test_build
    evax = Evax.new( "#{FIXTURES}/assets.yml", "#{File.dirname(__FILE__)}/.." )
    evax.expects( :build_js )
    evax.expects( :build_css )

    evax.build
  end

end
