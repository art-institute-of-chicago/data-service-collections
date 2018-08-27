class ArtworkPlace < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ObjectPlace'
  end

  def transform( data, ret )

    # Works have the following fields:
    # objectPlace, objectPlace_uri, objectPlace_uid

    ret[:is_preferred] = data.get(:isPreferred, false) === "true" || data.get(:preferred, false) === 1 # isPreferred": "true"

    # location_uid, location_uri, locationName
    ret[:place_id] = str2int( data.get(:location_uid) ) || data.get(:placeFkey, false) rescue nil

    # qualifier_uid, qualifier_uri, qualifierText
    ret[:place_qualifier_id] = str2int( data.get(:qualifier_uid) ) || data.get(:qualifierFkey, false) rescue nil

    if ret[:place_qualifier_id] === 0
      ret[:place_qualifier_id] = nil
    end

    # Catch transformations that need to occur with JSON blobs
    ret[:id] = ret[:id] || Integer( data.get(:pkey, false) ) rescue nil
    ret[:citi_id] = ret[:citi_id] || Integer( data.get(:pkey, false) ) rescue nil

    ret

  end
end
