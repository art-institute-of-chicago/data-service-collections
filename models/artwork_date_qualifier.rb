class ArtworkDateQualifier < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ObjectDateQualifier'
  end

  def transform( data, ret )

    # We are only interested in the citiUid and the prefLabel

    ret

  end
end
