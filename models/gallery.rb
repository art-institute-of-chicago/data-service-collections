class Gallery < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Place'
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
    ret[:number] = Integer( data.get(:galleryNumber) )
    ret[:floor] = Integer( data.get(:galleryFloor) ) # two results w/ 0
    ret[:category] = data.get(:publishCategory) # TODO: Change to ids

    ret

  end
end
