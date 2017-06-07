class Artist < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Agent'
  end

  def transform( data, ret )

    ret[:date_birth] = data.get(:birthDate)
    ret[:date_death] = data.get(:deathDate)

    ret

  end
end
