class ArtworkPlace < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ObjectPlace'
  end

  def transform( data, ret )

    # Works have the following fields:
    # objectPlace, objectPlace_uri, objectPlace_uid

    ret[:is_preferred] = data.get(:isPreferred, false) === "true" # isPreferred": "true"

    # location_uid, location_uri, locationName
    ret[:place_id] = str2int( data.get(:location_uid) )

    # qualifier_uid, qualifier_uri, qualifierText
    ret[:place_qualifier_id] = str2int( data.get(:qualifier_uid) )

    ret

  end
end
