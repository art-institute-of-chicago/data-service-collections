class ArtworkAgentRole < BaseModel

  def initialize
    super
    self.fq = 'hasModel:AgentRole'
  end

  def transform( data, ret )

    # Qualifier for ArtworkAgent's role, e.g. "Engraved by"
    # Waiting on Redmine #2371 to resolve this issue

    ret

  end
end
