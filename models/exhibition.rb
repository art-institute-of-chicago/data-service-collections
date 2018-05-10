class Exhibition < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Exhibition'
    self.fq << ' AND -exhibitionType:"Non AIC Venues only" AND -exhibitionStatus:"Not assigned" AND -exhibitionStatus:"Pending"'
  end

  def transform( data, ret )

    ret[:exhibition_type] = data.get(:exhibitionType, false)
    ret[:exhibition_status] = data.get(:exhibitionStatus, false)

    ret[:department_display] = data.get(:department)

    ret[:description] = data.get(:description)

    ret[:gallery] = data.get(:galleryLocation)
    ret[:gallery_id] = str2int( data.get(:gallery_uid) )

    ret[:aic_start_date] = Time.parse(data.get(:aicStartDate, false)).utc.iso8601 rescue nil
    ret[:aic_end_date] = Time.parse(data.get(:aicEndDate, false)).utc.iso8601 rescue nil

    ret[:start_date] = Time.parse(data.get(:startDate, false)).utc.iso8601 rescue nil
    ret[:end_date] = Time.parse(data.get(:endDate, false)).utc.iso8601 rescue nil

    # exhibitionPlace, exhibitionPlace_uris, exhibitionPlace_uids
    ret[:exhibition_agent_ids] = str2int( data.get(:exhibitionPlace_uid, false) )
    ret[:exhibition_agents] = pivot( ExhibitionAgent, ret[:exhibition_agent_ids] )

    # exhibitionObject, exhibitionObject_uris, exhibitionObject_uids
    # These are direct links to works, not to pivot models!
    ret[:artwork_ids] = str2int( data.get(:exhibitionObject_uid, false) )

    ret[:document_ids] = Uri2Guid( data.get(:hasDocument_uri, false) )

    # Remove prefImage from docs just in case
    if ret[:document_ids] && ret[:image_guid]
      ret[:document_ids].delete( ret[:image_guid] )
    end

    # TODO: Rename this field to image_id
    # TODO: Rename this field to pref_image_id?
    ret[:image_guid] = Uri2Guid( data.get(:hasPreferredRepresentation_uri) )

    # TODO: Rename this field to alt_image_id?
    ret[:alt_image_guids] = Uri2Guid( data.get(:hasRepresentation_uri, false) )

    # Remove the prefImage from the altImages array
    if ret[:alt_image_guids] && ret[:image_guid]
      ret[:alt_image_guids].delete( ret[:image_guid] )
    end

    # Remove documents from altImages
    # "When [interpretive resources] were migrated, they were added as both representations and documentation"
    if ret[:alt_image_guids] && ret[:document_ids]
      ret[:alt_image_guids] = ret[:alt_image_guids] - ret[:document_ids]
    end

    ret

  end
end
