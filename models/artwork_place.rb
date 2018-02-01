class ArtworkPlace < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ObjectPlace'
  end

  def transform( data, ret )

    # Works have the following fields:
    # objectPlace, objectPlace_uri, objectPlace_uid

    ret[:is_preferred] = data.get(:isPreferred, false) === "true" # isPreferred": "true"

    # TODO: There's no prefLabel. Use locationName instead?
    # If we could import places, we could use this model as a simple pivot,
    # but LPM Solr doesn't provide such fields currently.

    # TODO: Import place qualifiers. ObjectPlace has the following fields in LPM Solr:
    # qualifier_uid, qualifier_uri, qualifierText

    ret[:place_qualifier_id] = Lake2Citi( data.get(:qualifier_uid) )

    # Waiting on Redmine #2425 to resolve this

    ret

  end
end
