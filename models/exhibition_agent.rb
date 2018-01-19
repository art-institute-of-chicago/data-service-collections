# LPM Solr gives this to us as ExhibitionPlaces, but their records lump together agents and places.
# We're interested in Agents, and we'll pull the preferred place of the Agent if needed, so we're
# naming this class based on how we're using the data, not how it's named in the source.
class ExhibitionAgent < BaseModel

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

    ret[:agent] = data.get(:agentName, false)
    ret[:agent_id] = Lake2Citi( data.get(:agent_uid) )

    ret

  end
end
