module Herd
  module AssetSerializable
    extend ActiveSupport::Concern

    included do
      has_many :assets, serializer: Herd::AssetSerializer, embed: :ids, include: true
    end
    
    def assetable_object
      object
    end
    def assets
      assetable_object.assets_missing
    end
  end
end
