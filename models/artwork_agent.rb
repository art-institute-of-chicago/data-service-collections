class ArtworkAgent < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ObjectAgent'
  end

  def transform( data, ret )

    # Works have the following fields:
    # objectAgent, objectAgent_uri, objectAgent_uid

    ret[:is_preferred] = data.get(:isPreferred, false) === "true" # isPreferred": "true"

    # agent_uid, agent_uri, agentName
    ret[:agent_id] = Lake2Citi( data.get(:agent_uid) )

    # role_uid, role_uri, roleText
    ret[:role_id] = Lake2Citi( data.get(:role_uid) )

    ret

  end
end
