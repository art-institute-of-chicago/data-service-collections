class ArtworkCatalogue < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ObjectCatalogRaisonne'
  end

  def transform( data, ret )

    # Works have the following fields:
    # objectCatalogRaisonnesJSON, objectCatalogRaisonne, objectCatalogRaisonne_uri, objectCatalogRaisonne_uid
    # There is still a mixed bag of records that use objectCatalogRaisonnesJSON vs. objectCatalogRaisonne_uid, so we'll
    # need to account for both. ntrivedi, 8.13.18

    ret[:is_preferred] = data.get(:isPreferred, false) === "true" # isPreferred": "true"

    ret[:number] = data.get(:number, false)
    ret[:state_edition] = data.get(:stateEdition, false)
    ret[:catalog_id] = str2int( data.get(:catalogRaisonneName_uid) )

    # Catch transformations that need to occur with JSON blobs the source returns
    ret[:id] = ret[:id] || Integer( data.get(:pkey, false) ) rescue nil
    ret[:citi_id] = ret[:citi_id] || Integer( data.get(:pkey, false) ) rescue nil
    ret[:lake_guid] = ret[:lake_guid] || data.get(:parent_lake_guid, false) + "/objectCatalogRaisonnes/" + ret[:citi_id].to_s rescue nil
    ret[:lake_uri] = ret[:lake_uri] || data.get(:parent_lake_uri, false) + "/objectCatalogRaisonnes/" + ret[:citi_id].to_s rescue nil
    ret[:lake_uid] = ret[:lake_uid] || data.get(:pkey, false) rescue nil

    ret[:is_preferred] = ret[:is_preferred] || data.get(:preferred, false) === 1 # preferred": 1
    ret[:catalog_id] = ret[:catalog_id] || data.get(:catalogRaisonneFkey, false) rescue nil

    ret

  end
end
