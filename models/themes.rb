# Model class for Themes
class Theme < BaseModel

  def initialize
    super
    # TODO: Remove the OR once pubCatType:3 is fixed
    self.fq = 'hasModel:PublishCategory AND (pubCatType:3 OR citiUid:142)'
  end

  def transform( data, ret )

    ret[:description] = data.get(:description)

    ret[:is_in_nav] = data.get(:isInNav) == "True" ? true : false;
    ret[:sort] = data.get(:sort, true, true)

    ret

  end
end
