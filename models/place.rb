class Place < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Place'
    # Using galleryNumber excludes 20 places, such as Terzo Piano, Modern Wing Entrance, etc.
    # https://lakesolridxweb.artic.edu/solr/lpm_prod/select?wt=json&q=hasModel%3APlace+AND+galleryFloor%3A%5B*+TO+*%5D%20AND%20-galleryNumber:[*%20TO%20*]
    # self.fq << ' AND galleryNumber:[* TO *]'
    # self.fq << ' AND galleryFloor:[* TO *]'
    # Only 46 of 287 Galleries in Solr have the below condition:
    # self.fq << ' AND locationType:"AIC Gallery"'
    self.fq << ' AND -type:"http://definitions.artic.edu/ontology/1.0/WebMobilePublished"'
  end

  def transform( data, ret )

    if (BigDecimal.new(data.get(:latitude, false)) < 999)
      ret[:latitude] = data.get(:latitude, false)
    end

    if (BigDecimal.new(data.get(:longitude, false)) < 999)
      ret[:longitude] = data.get(:longitude, false)
    end

    ret[:type] = data.get(:locationType)

    # I don't want to pass names. Waiting until we get GUIDs.
    # ret[:category] = data.get(:publishCategory)

    ret

  end
end
