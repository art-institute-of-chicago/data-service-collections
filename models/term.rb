class Term < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Term'
    # TODO: Verify that we aren't importing terms of unwanted types
  end

  def transform( data, ret )

    ret[:id] = data.get(:uid)

    # termType_uri, termType_uid
    ret[:term_type_id] = str2int( data.get(:termType_uid) )

    ret

  end
end
