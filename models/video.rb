class Video < ResourceModel

  def initialize
    super
    self.fq = 'type:"http://definitions.artic.edu/ontology/1.0/type/MovingImage"'
  end

  def transform( data, ret )

    ret = super( data, ret )

    ret

  end
end
