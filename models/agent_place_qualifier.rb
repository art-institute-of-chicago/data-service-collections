class AgentPlaceQualifier < BaseModel

  def initialize
    super
    self.fq = 'hasModel:AgentPlaceQualifier'
  end

  def transform( data, ret )

    ret

  end
end
