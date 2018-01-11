class ArtworkCopyrightRepresentative < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ObjectCopyrightRepresentative'
  end

  def transform( data, ret )

    # Works have the following fields:
    # objectCopyrightRepresentatives, objectCopyrightRepresentatives_uris, objectCopyrightRepresentatives_uids

    ret[:is_preferred] =  data.get(:isPreferred, false) === "true" # isPreferred": "true"

    # TODO: Pull in an identifier that links to the actual Agent
    # agent_uid, agent_uri, agentName

    # agentRoleName can be ignored

    ret

  end
end
