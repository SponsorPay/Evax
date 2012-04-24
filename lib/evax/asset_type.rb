require_relative "asset_type/javascript"
require_relative "asset_type/stylesheet"

module AssetType
  def self.all
    [Javascript, Stylesheet]
  end
end
