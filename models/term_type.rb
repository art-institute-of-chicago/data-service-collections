class TermType < BaseModel

  def initialize
    super
    # TT-1 = Classification
    # TT-2 = Media/Material
    # TT-3 = Process/Techniques
    # TT-4 = Style/Period
    # TT-5 = Subject
    self.fq = 'hasModel:TermType AND (uid:TT-1 OR uid:TT-2 OR uid:TT-3 OR uid:TT-4 OR uid:TT-5)'
  end

  def transform( data, ret )

    ret

  end
end
