class ObjectType < BaseModel

  def initialize
    super
    self.fq = 'hasModel:ObjectType'
  end

  def transform( data, ret )

    ret

  end
end
