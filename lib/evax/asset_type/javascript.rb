require "uglifier"

module AssetType
  class Javascript
    def self.name
      "javascripts"
    end

    def self.file_extension
      "js"
    end

    def self.compress( content )
      opts = { :copyright => false }
      Uglifier.compile( content, opts )
    end
  end
end
