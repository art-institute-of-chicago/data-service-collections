# Model class for Galleries
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

  def transform( data )

    # We are aiming to use the LPM fields only, for forwards compatibility
    # Everything below the `id` field is drawn from CITI's Web Solr instance

    ret = {}
    ret[:id] = data.get(:citiUid, true, true)
    ret[:title] = data.get(:title)

    ret[:ids] = {}
    ret[:ids][:citi] = data.get(:citiUid, true, true)
    ret[:ids][:lake] = {}
    ret[:ids][:lake][:uid] = data.get(:uid)
    ret[:ids][:lake][:guid] = data.get(:id, false)
    ret[:ids][:lake][:uri] = data.get(:uri, false)

    ret[:titles] = {}
    ret[:titles][:raw] = data.get(:title)
    ret[:titles][:display] = data.get(:prefLabel)

    ret[:closed] = isClosed( data.get(:isClosed) )
    ret[:number] = data.get(:galleryNumber, true, true)
    ret[:category] = data.get(:publishCategory)

    ret[:created_at] = data.get(:created)
    ret[:created_by] = data.get(:createdBy)
    ret[:modified_at] = data.get(:lastModified)
    ret[:modified_by] = data.get(:lastModifiedBy)

    ret
  end
end
