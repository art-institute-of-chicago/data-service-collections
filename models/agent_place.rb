class AgentPlace < BaseModel

  def initialize
    super
    self.fq = 'hasModel:AgentPlace'
  end

  def transform( data, ret )

    # Works have the following fields:
    # agentPlace, agentPlace_uri, agentPlace_uid

    ret[:title] = data.get(:locationName, false)
    ret[:place_id] = Lake2Citi(data.get(:location_uid))
    ret[:qualifier] = data.get(:qualifierText, false)
    ret[:is_preferred] = data.get(:isPreferreddd, false) === "true"

    ret

  end
end
