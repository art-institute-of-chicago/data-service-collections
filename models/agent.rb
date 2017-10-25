class Agent < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Agent'
  end

  def transform( data, ret )

    ret[:date_birth] = data.get(:birthDate) ? Integer( Date.parse( data.get(:birthDate) ).strftime('%Y') ) : nil
    ret[:date_death] = data.get(:deathDate) ? Integer( Date.parse( data.get(:deathDate) ).strftime('%Y') ) : nil

    ret

  end
end
