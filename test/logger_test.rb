require_relative "test_helper"

class LoggerTest < Test::Unit::TestCase
  def test_log
    IO.any_instance.expects( :puts ).with( "[Evax 2001-02-01 04:05:06] hello!" )
    
    Delorean.time_travel_to( "2001-02-01 04:05:06" ) do
      Evax::Logger.log( "hello!" )
    end
  end
end