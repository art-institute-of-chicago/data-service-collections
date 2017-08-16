# AFAICT, Images do not contain Interpretive Resource fields
# If so, it's pointless to extend ResourceModel
class Image < BaseModel

  def initialize
    super
    # TODO: Several internal images snuck into the LPM, but don't appear in the LPM IIIF
    self.fq = 'type:*StillImage -type:*InternalUseOnly'
  end

  def transform( data, ret )

    ret = super( data, ret )

    # TODO: Derive type of image by this field?
    # https://lakesolridxweb.artic.edu/solr/lpm/select?wt=json&rows=0&facet.field=documentType_uri

    ret

  end
end

