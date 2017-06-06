class GradeLevel < BaseModel

  def initialize
    super
    self.fq = 'hasModel:GradeLevel'
  end

  def transform( data, ret )

    ret

  end
end
