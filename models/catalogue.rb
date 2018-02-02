class Catalogue < BaseModel

  def initialize
    super
    self.fq = 'hasModel:CatalogRaisonne'
  end

  def transform( data, ret )

    # We are only interested in CITI UID and prefLabel

    ret

  end
end
