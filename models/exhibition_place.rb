class ExhibitionPlace < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ExhibitionPlace'
  end

  def transform( data, ret )

    # Works have the following fields:
    # exhibitionPlace, exhibitionPlace_uri, exhibitionPlace_uid

    ret[:start_date] = Time.parse(data.get(:startDate, false)).utc.iso8601
    ret[:end_date] = Time.parse(data.get(:endDate, false)).utc.iso8601

    ret[:is_host] = data.get(:isHost, false) === "true"
    ret[:is_organizer] = data.get(:isOrganizer, false) === "true"

    ret[:place] = data.get(:locationName, false)
    ret[:agent] = data.get(:agentName, false)

    # TODO: There's no prefLabel. Use locationName instead?
    # If we could import places, we could use this model as a simple pivot,
    # but LPM Solr doesn't provide such fields currently.

    # TODO: Import place qualifiers. ObjectPlace has the following fields in LPM Solr:
    # qualifier_uid, qualifier_uri, qualifierText

    ret

  end
end
