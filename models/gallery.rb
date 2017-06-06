class Gallery < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Place'
  end

  # TODO: Abstract boolean into lake_unwrapper.rb (?)
  # isClosed contains some irregularities that prevent it from abstraction
  def isClosed( data )

    # default to expectations...
    return true if data == "True"
    return false

    # other responses, for reference:
    return false if data == nil
    return false if data == "False"
    return false if data == "<NOT Closed>"

  end

  def transform( data, ret )

    ret[:closed] = isClosed( data.get(:isClosed) )
    ret[:number] = data.get(:galleryNumber, true, true)
    ret[:floor] = data.get(:galleryFloor, true, true) # one result w/ 0
    ret[:category] = data.get(:publishCategory)

    ret

  end
end
