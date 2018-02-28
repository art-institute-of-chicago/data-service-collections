class TermType < BaseModel

  def initialize
    super
    self.fq = 'hasModel:TermType'
  end

  def transform( data, ret )

    ret

  end
end
