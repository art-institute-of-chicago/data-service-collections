class ArtworkDate < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ObjectDate'
  end

  def transform( data, ret )

    # Works have the following fields:
    # objectDate, objectDate_uris, objectDate_uids

    # earliestDate, latestDate, isPreferred
    ret[:date_earliest] = data.get(:earliestDate) || data.get(:earlyISO, false) rescue nil
    ret[:date_latest] = data.get(:latestDate) || data.get(:lateISO, false) rescue nil
    ret[:is_preferred] =  data.get(:isPreferred, false) === "true" || data.get(:preferred, false) === 1  # isPreferred": "true"

    # TODO: Import date qualifiers. ObjectDate has the following fields in LPM Solr:
    # qualifier_uid, qualifier_uri, qualifierText

    ret[:date_qualifier_id] = str2int( data.get(:qualifier_uid) ) || data.get(:qualifierFkey, false) rescue nil

    if ret[:date_qualifier_id] === 0
      ret[:date_qualifier_id] = nil
    end

    # Catch transformations that need to occur with JSON blobs
    ret[:id] = ret[:id] || Integer( data.get(:pkey, false) ) rescue nil
    ret[:citi_id] = ret[:citi_id] || Integer( data.get(:pkey, false) ) rescue nil

    ret

  end
end
