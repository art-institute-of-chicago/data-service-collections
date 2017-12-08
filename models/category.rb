class Category < BaseModel

  def initialize
    super
    self.fq = 'hasModel:PublishCategory'
  end

  def transform( data, ret )

    # Launch CITI, go to Enter > List Editor, select "Publish Categories"

    # pubCatType ranges 1 to 7 inclusive
    # https://lakesolridxweb.artic.edu/solr/lpm/select?wt=json&facet.limit=-1&rows=0&facet.field=pubCatType
    # https://lakesolridxweb.artic.edu/solr/lpm/select?wt=json&fl=title&q=pubCatType:6
    # 1 (121) = Departmental
    # 2 (193) = Subject
    # 3   (8) = Themes
    # 4 (432) = Exhibition
    # 5   (6) = Multimedia -> Artist Talk, Collection Focus, etc.
    # 6  (28) = Collection
    #           Seems to be retired http://www.artic.edu/aic/collections/artwork/category/212
    # 7   (1) = Featured -> Featured Objects

    ret[:description] = data.get(:description)

    ret[:is_in_nav] = data.get(:isInNav) == "True" ? true : false;

    # parentCitiUid is used for nesting, e.g. 629 and 648
    ret[:parent_id] = Integer( data.get(:parentCitiUid) ) rescue nil

    # sort is relative to siblings on same level, not global
    # recommend sort by `sort`, then by `title`
    # this mirrors citi's sorting
    ret[:sort] = Integer( data.get(:sort) ) rescue nil

    ret[:type] = Integer( data.get(:pubCatType) )

    ret

  end
end
