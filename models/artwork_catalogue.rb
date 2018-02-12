class ArtworkCatalogue < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ObjectCatalogRaisonne'
  end

  def transform( data, ret )

    # Works have the following fields:
    # objectCatalogRaisonne, objectCatalogRaisonne_uri, objectCatalogRaisonne_uid

    ret[:is_preferred] = data.get(:isPreferred, false) === "true" # isPreferred": "true"

    ret[:number] = data.get(:number, false)
    ret[:state_edition] = data.get(:stateEdition, false)
    ret[:catalog_id] = str2int( data.get(:catalogRaisonneName_uid) )

    ret

  end
end
