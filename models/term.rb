class Term < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Term'
  end

  def transform( data, ret )

    # We are only interested in the citiUid and the prefLabel

    # TODO: Connect `hasModel:ObjectTerm` to `hasModel:Term` when fields become available
    # TODO: Connect `hasModel:TermType` to `hasModel:Term` – see Redmine #2407

    ret

  end
end
