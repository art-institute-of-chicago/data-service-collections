class Exhibition < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Exhibition'
    self.fq << ' AND -exhibitionType:"Non AIC Venues only" AND -exhibitionStatus:"Not assigned" AND -exhibitionStatus:"Pending"'
  end

  def transform( data, ret )

    ret[:exhibition_type] = data.get(:exhibitionType, false)
    ret[:exhibition_status] = data.get(:exhibitionStatus, false)

    ret[:department] = data.get(:department)
    ret[:department_id] = Integer( data.get(:department_citiUid) ) rescue nil

    ret[:description] = data.get(:description)

    ret[:gallery] = data.get(:galleryLocation)

    ret[:image_guid] = Uri2Guid( data.get(:hasPreferredRepresentation_uri) )

    ret[:aic_start_date] = Time.parse(data.get(:aicStartDate, false)).utc.iso8601 rescue nil
    ret[:aic_end_date] = Time.parse(data.get(:aicEndDate, false)).utc.iso8601 rescue nil

    ret[:start_date] = Time.parse(data.get(:startDate, false)).utc.iso8601 rescue nil
    ret[:end_date] = Time.parse(data.get(:endDate, false)).utc.iso8601 rescue nil

    # exhibitionPlace, exhibitionPlace_uris, exhibitionPlace_uids
    ret[:exhibition_agent_ids] = str2int( data.get(:exhibitionPlace_uid, false) )

    # exhibitionObject, exhibitionObject_uris, exhibitionObject_uids
    # TODO: There's currently no data here. Revisit this when we can see what we're getting.
    ret[:artwork_ids] = uid2id( data.get(:exhibitionObject_uid, false) )

    ret

  end
end
