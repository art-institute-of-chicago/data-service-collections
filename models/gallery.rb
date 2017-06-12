class Gallery < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Place'
    self.fq << ' AND locationType_uri:"AIC Gallery"'
  end

  # TODO: Abstract boolean into lake_unwrapper.rb (?)
  # isClosed contains some irregularities that prevent it from abstraction
  # https://lakesolridxweb.artic.edu/solr/lpm/select?wt=json&facet.field=isClosed&facet.limit=-1&rows=0
  def isClosed( data )

    # default to expectations...
    return true if data == "<Closed>"

    return false if data == "<NOT Closed>"
    return false

    # historic responses, for reference:
    return false if data == nil
    return true if data == "True"
    return false if data == "False"
    return false if data == "<NOT Closed>"

  end

  def transform( data, ret )

    ret[:closed] = isClosed( data.get(:isClosed) )

    # Some galleryNumbers are NOT numbers, e.g. 297A
    ret[:number] = data.get(:galleryNumber)

    ret[:floor] = Integer( data.get(:galleryFloor) ) # two results w/ 0

    ret[:latitude] = data.get(:latitude, false)
    ret[:longitude] = data.get(:longitude, false)

    # I don't want to pass names. Waiting until we get GUIDs.
    # ret[:category] = data.get(:publishCategory)

    ret

  end
end
