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

    ret

  end
end
