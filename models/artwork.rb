class Artwork < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Work'
  end

  def transform( data, ret )

    ret[:main_id] = data.get(:mainRefNumber) # unusual for this model

    ret[:date_display] = data.get(:dateDisplay)
    ret[:date_start] = Integer( data.get(:earliestYear) ) rescue nil # can be derived from dates?
    ret[:date_end] = Integer( data.get(:latestYear) ) rescue nil # can be derived from dates?

    ret[:creator_id] = Lake2Citi( data.get(:artist_uid) )
    ret[:creator_display] = data.get(:creatorDisplay)

    ret[:image_guid] = Uri2Guid( data.get(:hasPreferredRepresentation_uri) )

    # TODO: Get coordinates from mobile app CMS
    # https://lakesolridxweb.artic.edu/solr/lpm/select?wt=json&rows=0&facet.limit=-1&facet.field=galleryLocation
    ret[:location] = data.get(:galleryLocation)

    ret[:description] = data.get(:description)

    ret[:department_id] = Lake2Citi( data.get(:department_uid) )

    ret[:dimensions] = data.get(:dimensionsDisplay)

    ret[:medium] = data.get(:mediumDisplay)

    ret[:credit_line] = data.get(:creditLine)

    ret[:copyright] = data.get(:copyrightNotice, false)

    ret[:inscriptions] = data.get(:inscriptions)

    ret[:publications] = data.get(:publicationHistory)
    ret[:exhibitions] = data.get(:exhibitionHistory)
    ret[:provenance] = data.get(:provenanceText)

    # TODO: Change this to publishCategory_citiUid once that's available
    # TODO: It's available! publishCategory and publishCategoryUid
    ret[:category_ids] = data.get(:published_category_i, false)

    # TODO: Add this to Exhibitions as well
    # hasDocument_uid, hasDocument_uri, hasDocument
    ret[:document_ids] = Lake2Citi( data.get(:hasDocument_uid, false) )

    # All the `:artwork_*_ids` fields below point at "pivot" objects
    # We need to import these pivot objects, then use them to relate artworks to the "actual" linked object
    # Most of these "pivot" objects have extra fields elaborating on the relationship

    # objectAgent, objectAgent_uri, objectAgent_uid
    # citiUid, agent_uid, isPreferred
    ret[:artwork_agent_ids] = str2int( data.get(:objectAgent_uid, false) )

    # objectCatalogRaisonne, objectCatalogRaisonne_uri, objectCatalogRaisonne_uid
    ret[:artwork_catalog_ids] = str2int( data.get(:objectCatalogRaisonne_uid, false) )

    # TODO: Watch Redmine ticket #2424
    ret[:copyright_representative_ids] = str2int( data.get(:objectCopyrightRepresentatives_uids, false) )

    # objectDate, objectDate_uri, objectDate_uid
    # earliestDate, latestDate, isPreferred, qualifierText
    ret[:artwork_date_ids] = str2int( data.get(:objectDate_uid, false) )

    # objectPlace, objectPlace_uri, objectPlace_uid
    ret[:artwork_place_ids] = str2int( data.get(:objectPlace_uid, false) )

    # objectTerms, objectTerms_uris, objectTerms_uids
    ret[:artwork_term_ids] = str2int( data.get(:objectTerms_uids, false) )

    # TODO: Watch Redmine ticket #2423
    ret[:alt_titles] = data.get(:altLabel, false)

    # TODO: All of the fields below still need to be considered

    # collectionStatus

    # objectCommittee - an array of strings

    # objectTypes

    # constituentPart_uid, constituentPart_uri, constituentPart
    ret[:part_ids] = str2int( data.get(:constituentPart_uid, false) )

    # compositeWhole_uid, compositeWhole_uri, compositeWhole
    ret[:set_ids] = str2int( data.get(:compositeWhole_uid, false) )


    ret

  end
end
