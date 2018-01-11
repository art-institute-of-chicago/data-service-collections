class ArtworkTitle < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ObjectTitle'
  end

  def transform( data, ret )

    # TODO: Preferred title is not always first! Filter it out downstream?

    ret[:is_preferred] =  data.get(:isPreferred, false) === "true" # isPreferred": "true"

    # TODO: LPM Solr is missing `language` or `languageText`, but they are in Fedora
    # We want `language_uid`, i.e. the linked language's identifier
    # We can do without tracking language for each title however.

    # language, languageText

    ret

  end
end
