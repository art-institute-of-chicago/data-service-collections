class ArtworkCopyrightRepresentative < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ObjectCopyrightRepresentative'
  end

  def transform( data, ret )

    # Works have the following fields:
    # objectCopyrightRepresentatives, objectCopyrightRepresentatives_uris, objectCopyrightRepresentatives_uids

    # Interestingly, ObjectCopyrightRepresentatives are never preferred
    # ret[:is_preferred] =  data.get(:isPreferred, false) === "true" # isPreferred": "true"

    # TODO: Pull in an identifier that links to the actual Agent
    # agent_uid, agent_uri, agentName

    ret[:agent_id] = Lake2Citi( data.get(:agent_uid) )

    # agentRoleName can be ignored

    # Waiting on Redmine #2424 to resolve this

    ret

  end
end
