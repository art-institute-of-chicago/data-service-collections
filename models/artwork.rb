class Artwork < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Work'
  end

  def transform( data, ret )

    # Explicitly enforced in case we start using prefLabel in model_base.rb [#2423]
    ret[:title] = data.get(:title)
    ret[:alt_titles] = data.get(:altTitle, false)

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

    # This is always an array of strings
    ret[:committees] = data.get(:objectCommittee, false)

    # TODO: Change this to publishCategory_citiUid once that's available
    # TODO: It's available! publishCategory and publishCategoryUid
    ret[:category_ids] = data.get(:published_category_i, false)

    # TODO: Add this to Exhibitions as well
    # hasDocument_uid, hasDocument_uri, hasDocument
    ret[:document_ids] = Lake2Citi( data.get(:hasDocument_uid, false) )

    # All the `:artwork_*_ids` fields below point at "pivot" objects
    # We need to import these pivot objects, then use them to relate artworks to the "actual" linked object
    # Most of these "pivot" objects have extra fields elaborating on the relationship

    # TODO: Watch Redmine ticket #2371
    # objectAgent, objectAgent_uri, objectAgent_uid
    # ret[:artwork_agent_ids] = str2int( data.get(:objectAgent_uid, false) )

    # objectCatalogRaisonne, objectCatalogRaisonne_uri, objectCatalogRaisonne_uid
    ret[:artwork_catalogue_ids] = str2int( data.get(:objectCatalogRaisonne_uid, false) )

    # TODO: Watch Redmine ticket #2424
    # ret[:copyright_representative_ids] = str2int( data.get(:objectCopyrightRepresentatives_uids, false) )

    # objectDate, objectDate_uri, objectDate_uid
    ret[:artwork_date_ids] = str2int( data.get(:objectDate_uid, false) )

    # TODO: Watch Redmine ticket #2425
    # objectPlace, objectPlace_uri, objectPlace_uid
    # ret[:artwork_place_ids] = str2int( data.get(:objectPlace_uid, false) )

    # TODO: Watch Redmine ticket #2407
    # objectTerms, objectTerms_uris, objectTerms_uids
    # ret[:artwork_term_ids] = str2int( data.get(:objectTerms_uids, false) )


    # TODO: All of the fields below still need to be considered

    # collectionStatus

    # TODO: Watch Redmine ticket #2431
    # objectTypes

    # This produces an Artwork's CITI UID
    # constituentPart_uid, constituentPart_uri, constituentPart
    ret[:part_ids] = Lake2Citi( data.get(:constituentPart_uid, false) )

    # This produces an Artwork's CITI UID
    # compositeWhole_uid, compositeWhole_uri, compositeWhole
    ret[:set_ids] = Lake2Citi( data.get(:compositeWhole_uid, false) )

    ret[:is_public_domain] = data.get(:type, false).include? 'http://definitions.artic.edu/ontology/1.0/PCRightsPublicDomain'

    ret[:is_zoomable] = (data.get(:type, false).include? 'http://definitions.artic.edu/ontology/1.0/PCRightsWebEdu') || ret[:is_public_domain] || ret[:copyright] || false

    if ret[:copyright]
      ret[:max_zoom_window_size] = 1280
    elsif ret[:is_zoomable]
      ret[:max_zoom_window_size] = -1
    else
      ret[:max_zoom_window_size] = 843
    end

    ret[:place_of_origin] = data.get(:placeOfOrigin)

    ret[:publishing_verification_level] = data.get(:publicationVerificationLevel, false)

    ret[:collection_status] = data.get(:collectionStatus, false)

    ret

  end
end
