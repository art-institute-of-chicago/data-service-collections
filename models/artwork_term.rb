class ArtworkTerm < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ObjectTerm'
  end

  def transform( data, ret )

    # Works have the following fields:
    # objectTerms, objectTerms_uris, objectTerms_uids

    # TODO: This field is actually missing in this case
    ret[:is_preferred] =  data.get(:isPreferred, false) === "true" # isPreferred": "true"

    # TODO: This model is linked to `hasModel:Term` but there's no fields in LPM Solr to connect them
    # term_uid, term_uri, term

    # termType is a field available here, but if we import terms directly, we don't need it

    # TODO: Term type is available via a link, but there's no fields in LPM Solr to connect them
    # termType_uid, termType_uri, termType

    ret

  end
end
