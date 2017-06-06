# Model class for Departments
class AgentType < BaseModel

  def initialize
    super
    self.fq = 'hasModel:AgentType'
  end

  def transform( data, ret )

    ret

  end
end
