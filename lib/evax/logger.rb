module Evax::Logger
  def self.log( message )
    puts "[Evax #{Time.now.strftime( "%F %T" )}] #{message}"
  end
end