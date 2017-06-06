class Artwork < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Work'
  end

  def transform( data, ret )

    ret[:ids][:main] = data.get(:mainRefNumber) # unusual for this model

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

    ret[:inscriptions] = data.get(:inscriptions)
    ret[:credit_line] = data.get(:creditLine)

    ret[:history] = {}
    ret[:history][:publications] = data.get(:publicationHistory)
    ret[:history][:exhibitions] = data.get(:exhibitionHistory)
    ret[:history][:provenance] = data.get(:provenanceText)

    ret

  end
end
