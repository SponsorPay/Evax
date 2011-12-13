# inspired by: http://www.benengebreth.org/2010/01/minimizing-css-files-with-ruby

module Evax::CssMinifier

  def self.build(css_string)
    css_string.split('}').map do |block|
      block.gsub!(/\n/,' ')
      block.gsub!(/\/\*.*?\*\//m,'')
      block.gsub!(/\s*:\s*/, ':')
      block.gsub!(/\s*;\s*/, ';')
      block.gsub!(/\s*,\s*/, ',')
      block.gsub!(/\s*\{\s*/, '{')
      block.gsub!(/\s\s+/, ' ')

      block.strip + '}' if block.include?('{')
    end.join(' ')
  end

end