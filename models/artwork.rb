class Artwork < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Work'
  end

  def transform( data, ret )

    ret[:main_id] = data.get(:mainRefNumber) # unusual for this model

    ret[:date_display] = data.get(:dateDisplay)
    ret[:date_start] = Integer( data.get(:earliestYear) ) rescue nil
    ret[:date_end] = Integer( data.get(:latestYear) ) rescue nil

    ret[:creator_id] = Lake2Citi( data.get(:artist_uid) )
    ret[:creator_display] = data.get(:creatorDisplay)

    ret[:image_guid] = Uri2Guid( data.get(:hasPreferredRepresentation_uri) )

    # TODO: Get coordinates from mobile app CMS
    # https://lakesolridxweb.artic.edu/solr/lpm/select?wt=json&rows=0&facet.limit=-1&facet.field=galleryLocation
    ret[:location] = data.get(:galleryLocation)

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
    ret[:category_ids] = data.get(:published_category_i, false)

    ret[:document_guids] = Uri2Guid( data.get(:hasDocument_uri, false) )


    ret

  end
end
