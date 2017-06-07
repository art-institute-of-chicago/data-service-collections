class Artwork < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Work'
  end

  def transform( data, ret )

    ret[:main_id] = data.get(:mainRefNumber) # unusual for this model

    ret[:date_display] = data.get(:dateDisplay)
    ret[:date_start] = Integer( data.get(:earliestYear) )
    ret[:date_end] = Integer( data.get(:latestYear) )

    ret[:creator_id] = CitiId( data.get(:artist_uid) )
    ret[:creator_display] = data.get(:creatorDisplay)

    ret[:department_id] = CitiId( data.get(:department_uid) )

    ret[:dimensions] = data.get(:dimensionsDisplay)

    ret[:medium] = data.get(:mediumDisplay)

    ret[:credit_line] = data.get(:creditLine)

    ret[:inscriptions] = data.get(:inscriptions)

    ret[:publications] = data.get(:publicationHistory)
    ret[:exhibitions] = data.get(:exhibitionHistory)
    ret[:provenance] = data.get(:provenanceText)

    ret

  end
end
