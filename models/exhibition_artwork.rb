class ExhibitionArtwork < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ExhibitionArtwork'
  end

  def transform( data, ret )

    # Exhibitions have the following fields:
    # exhibitionObject, exhibitionObject_uri, exhibitionObject_uid

    # TODO: There are no example records in the LPM for us to see what data is available

    ret

  end
end
