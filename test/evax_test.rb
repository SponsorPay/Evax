require 'test/unit'
require "mocha"
require_relative "../lib/evax.rb"

FIXTURES = "#{File.dirname(__FILE__)}/fixtures"

class EvaxTest < Test::Unit::TestCase
  def test_initialize
    evax = Evax.new( "wadus", "tradus" )
    assert_equal( "wadus", evax.config_file )
    assert_equal( "tradus", evax.relative_path )
  end

  def test_read_config_file
    evax = Evax.new( "#{FIXTURES}/assets.yml", nil )
    assert_equal( "tmp/", evax.config["output_path"] )
    assert_equal( 2, evax.config["javascripts"].size )
  end

  def test_join
    evax = Evax.new( "#{FIXTURES}/assets.yml", "wadus" )

    [
      "wadus/test/fixtures/javascripts/one.js",
      "wadus/test/fixtures/javascripts/two.js",
      "wadus/test/fixtures/javascripts/three.js"
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
    evax = Evax.new( "#{FIXTURES}/assets.yml",  "#{File.dirname(__FILE__)}/.." )
    evax.expects( :write_output ).with( "js_one.js", File.read( "#{FIXTURES}/js_one.compress.js" ) )
    evax.expects( :write_output ).with( "js_two.js", File.read( "#{FIXTURES}/js_two.compress.js" ) )

    evax.build_js
  end

  def test_build_css
    evax = Evax.new( "#{FIXTURES}/assets.yml",  "#{File.dirname(__FILE__)}/.." )
    evax.expects( :write_output ).with( "css_one.css", File.read( "#{FIXTURES}/css_one.compress.css" ) )
    evax.expects( :write_output ).with( "css_two.css", File.read( "#{FIXTURES}/css_two.compress.css" ) )

    evax.build_css
  end

  def test_build
    evax = Evax.new( nil, nil )
    evax.expects( :build_js )
    evax.expects( :build_css )

    evax.build
  end

end