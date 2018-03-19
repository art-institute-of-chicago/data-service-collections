# I had to name this Group instead of Set b/c of namespacing
# Series's pluralization is too ambiguious for conventions
# When we migrate this to Laravel, rename this to Set
class Group < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Set'
  end

  def transform( data, ret )

    ret

  end
end
