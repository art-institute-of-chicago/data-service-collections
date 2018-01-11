class ArtworkDate < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ObjectDate'
  end

  def transform( data, ret )

    # Works have the following fields:
    # objectDate, objectDate_uris, objectDate_uids

    # earliestDate, latestDate, isPreferred
    ret[:date_earliest] = data.get(:earliestDate)
    ret[:date_latest] = data.get(:latestDate)
    ret[:is_preferred] =  data.get(:isPreferred, false) === "true" # isPreferred": "true"

    # TODO: Import date qualifiers. ObjectDate has the following fields in LPM Solr:
    # qualifierText, qualifier_uid, qualifier_uri

    ret

  end
end
