class Term < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Term AND (termType_uid:TT-1 OR termType_uid:TT-2 OR termType_uid:TT-3 OR termType_uid:TT-4 OR termType_uid:TT-5)'
  end

  def transform( data, ret )

    ret[:id] = data.get(:uid)

    # termType_uri, termType_uid
    ret[:term_type_id] = str2int( data.get(:termType_uid) )

    ret

  end
end
