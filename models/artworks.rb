# Model class for Artworks
class Artwork < BaseModel

  @@fq = 'hasModel:Work'


  def self.transform( data )

    # We are aiming to use the LPM fields only, for forwards compatibility
    # Everything below the `id` field is drawn from CITI's Web Solr instance

    ret = {}
    ret[:id] = data.get(:citiUid, true, true)
    ret[:title] = data.get(:title)

    ret[:ids] = {}
    ret[:ids][:citi] = data.get(:citiUid, true, true)
    ret[:ids][:main] = data.get(:mainRefNumber)
    ret[:ids][:lake] = {}
    ret[:ids][:lake][:hid] = data.get(:uid)
    ret[:ids][:lake][:guid] = data.get(:id)
    ret[:ids][:lake][:uri] = data.get(:uri)

    ret[:titles] = {}
    ret[:titles][:raw] = data.get(:title)
    ret[:titles][:display] = data.get(:prefLabel)

    ret[:dates] = {}
    ret[:dates][:start] = data.get(:earliestYear, true, true)
    ret[:dates][:end] = data.get(:latestYear, true, true)
    ret[:dates][:display] = data.get(:dateDisplay)

    ret[:creator] = {}
    ret[:creator][:id] = data.get(:artist_uid)
    ret[:creator][:raw] = data.get(:artist)
    ret[:creator][:display] = data.get(:creatorDisplay)

    ret[:department] = {}
    ret[:department][:id] = data.get(:department_uid)
    ret[:department][:display] = data.get(:department)

    ret[:dimensions] = data.get(:dimensionsDisplay)

    ret[:medium] = {}
    ret[:medium][:raw] = data.get(:medium)
    ret[:medium][:display] = data.get(:mediumDisplay)

    ret[:inscriptions] = data.get(:title, false)
    ret[:credit_line] = data.get(:creditLine)

    ret[:history] = {}
    ret[:history][:publications] = data.get(:publicationHistory)
    ret[:history][:exhibitions] = data.get(:exhibitionHistory)
    ret[:history][:provenance] = data.get(:provenanceText)

    ret[:created_at] = data.get(:created)
    ret[:created_by] = data.get(:createdBy)
    ret[:modified_at] = data.get(:lastModified)
    ret[:modified_by] = data.get(:lastModifiedBy)

    ret
  end
end
