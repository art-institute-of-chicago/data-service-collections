class ArtworkAgentRole < BaseModel

  def initialize
    super
    self.fq = 'hasModel:AgentRole'
  end

  def transform( data, ret )

    # Qualifier for ArtworkAgent's role, e.g. "Engraved by"

    ret

  end
end
