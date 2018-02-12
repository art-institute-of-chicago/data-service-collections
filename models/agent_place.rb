class AgentPlace < BaseModel

  def initialize
    super
    self.fq = 'hasModel:AgentPlace'
  end

  def transform( data, ret )

    # Works have the following fields:
    # agentPlace, agentPlace_uri, agentPlace_uid

    # We don't need to track title, since this is pivot model
    # ret[:title] = data.get(:locationName, false)

    # location_uid, location_uri, locationName
    ret[:place_id] = str2int( data.get(:location_uid) )

    # qualifier_uid, qualifier_uri, qualifierText
    ret[:qualifier_id] = str2int( data.get(:qualifier_uid) )

    ret[:is_preferred] = data.get(:isPreferred, false) === "true"

    ret

  end
end
