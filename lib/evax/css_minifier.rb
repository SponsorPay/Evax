# inspired by: http://www.benengebreth.org/2010/01/minimizing-css-files-with-ruby

module Evax::CssMinifier

  def self.build(css_string)
    css_string.gsub!(/\n/," ")
    css_string.gsub!(/\/\*.*?\*\//m,"")
    css_string.gsub!(/\s*:\s*/, ":")
    css_string.gsub!(/\s*;\s*/, ";")
    css_string.gsub!(/\s*,\s*/, ",")
    css_string.gsub!(/\s*\{\s*/, "{")
    css_string.gsub!(/\s\s+/, " ")
    css_string.gsub!(/^\s*/, "")
    css_string.gsub!(/\s!important/, "!important")
    css_string.gsub!(/;\s*\}\s*/, "}")
  end

end