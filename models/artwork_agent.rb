class ArtworkAgent < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ObjectAgent'
  end

  def transform( data, ret )

    # Works have the following fields:
    # objectAgent, objectAgent_uri, objectAgent_uid

    ret[:is_preferred] = data.get(:isPreferred, false) === "true" || data.get(:preferred, false) === 1 # isPreferred": "true"

    # agent_uid, agent_uri, agentName
    ret[:agent_id] = str2int( data.get(:agent_uid) ) || data.get(:agentFkey, false) rescue nil

    # role_uid, role_uri, roleText
    ret[:role_id] = str2int( data.get(:role_uid) ) || data.get(:roleFkey, false) rescue nil

    if ret[:role_id] === 0
      ret[:role_id] = nil
    end

    # Catch transformations that need to occur with JSON blobs
    ret[:id] = ret[:id] || Integer( data.get(:pkey, false) ) rescue nil
    ret[:citi_id] = ret[:citi_id] || Integer( data.get(:pkey, false) ) rescue nil

    ret

  end
end
