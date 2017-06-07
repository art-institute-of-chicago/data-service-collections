class Theme < BaseModel

  def initialize
    super
    self.fq = 'hasModel:PublishCategory AND pubCatType:3'
  end

  def transform( data, ret )

    ret[:description] = data.get(:description)

    ret[:is_in_nav] = data.get(:isInNav) == "True" ? true : false;
    ret[:sort] = Integer( data.get(:sort) )

    ret

  end
end
