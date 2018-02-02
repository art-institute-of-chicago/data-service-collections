class ArtworkCatalogue < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ObjectCatalogRaisonne'
  end

  def transform( data, ret )

    # Works have the following fields:
    # objectCatalogRaisonne, objectCatalogRaisonne_uri, objectCatalogRaisonne_uid

    ret[:is_preferred] = data.get(:isPreferred, false) === "true" # isPreferred": "true"

    # TODO: The following fields are in Fedora, but not LPM Solr
    # catalogRaisonneName, number, stateEdition

    ret[:number] = data.get(:number, false)
    ret[:state_edition] = data.get(:stateEdition, false)
    ret[:catalog_id] = uid2id(data.get(:catalogRaisonneName_uid))

    # TODO: Fedora has a link to `hasModel:CatalogRaisonne` via `catalogRaisonne` field
    # However, there's nothing in LPM Solr that we can use to retrieve its identifiers

    # Waiting on Redmine #2406 to resolve these issues

    ret

  end
end
