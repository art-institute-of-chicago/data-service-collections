class Department < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Department'
  end

  def transform( data, ret )

    ret

  end
end
