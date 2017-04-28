# Model class for Galleries
class Gallery < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Place'
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

    ret[:closed] = data.get(:isClosed).downcase == "true" ? true : false
    ret[:number] = data.get(:galleryNumber, true, true)
    ret[:category] = data.get(:publishCategory)

    ret[:created_at] = data.get(:created)
    ret[:created_by] = data.get(:createdBy)
    ret[:modified_at] = data.get(:lastModified)
    ret[:modified_by] = data.get(:lastModifiedBy)

    ret
  end
end
