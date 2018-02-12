class Agent < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Agent'
  end

  def transform( data, ret )

    # prefLabel, prefSortName, altLabel, altSortName
    ret[:title_sort] = data.get(:prefSortName)
    ret[:alt_titles] = data.get(:altLabel, false)

    # We don't care about altSortName (tbd)

    ret[:date_birth] = data.get(:birthDate) ? Integer( Date.parse( data.get(:birthDate) ).strftime('%Y') ) : nil
    ret[:date_death] = data.get(:deathDate) ? Integer( Date.parse( data.get(:deathDate) ).strftime('%Y') ) : nil

    ret[:is_licensing_restricted] = data.get(:isLicensingRestricted, false) === "true"

    # agentType, agentType_uri, agentType_uid
    ret[:agent_type_ids] = Lake2Citi( data.get(:agentType_uid, false) )

    # agentPlace, agentPlace_uri, agentPlace_uid
    ret[:agent_place_ids] = str2int( data.get(:agentPlace_uid, false) )

    ret

  end
end
