require_relative "../css_minifier"

module AssetType
  class Stylesheet
    def self.name
      "stylesheets"
    end

    def self.file_extension
      "css"
    end

    def self.compress( content )
      Evax::CssMinifier.build( content )
    end
  end
end
