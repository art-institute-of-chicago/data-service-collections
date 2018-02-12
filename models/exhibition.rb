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
    ret[:gallery_id] = str2int( data.get(:gallery_uid) )

    ret[:image_guid] = Uri2Guid( data.get(:hasPreferredRepresentation_uri) )

    ret[:aic_start_date] = Time.parse(data.get(:aicStartDate, false)).utc.iso8601 rescue nil
    ret[:aic_end_date] = Time.parse(data.get(:aicEndDate, false)).utc.iso8601 rescue nil

    ret[:start_date] = Time.parse(data.get(:startDate, false)).utc.iso8601 rescue nil
    ret[:end_date] = Time.parse(data.get(:endDate, false)).utc.iso8601 rescue nil

    # exhibitionPlace, exhibitionPlace_uris, exhibitionPlace_uids
    ret[:exhibition_agent_ids] = str2int( data.get(:exhibitionPlace_uid, false) )

    # exhibitionObject, exhibitionObject_uris, exhibitionObject_uids
    # These are direct links to works, not to pivot models!
    ret[:artwork_ids] = str2int( data.get(:exhibitionObject_uid, false) )

    ret[:document_ids] = Uri2Guid( data.get(:hasDocument_uri, false) )

    ret

  end
end
