# Model class for Artists
class Artist < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Agent'
  end

  def transform( data, ret )

    ret[:dates] = {}
    ret[:dates][:birth] = data.get(:birthDate)
    ret[:dates][:death] = data.get(:deathDate)

    ret

  end
end
