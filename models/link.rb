class Link < ResourceModel

  def initialize
    super
    self.fq = 'legacyReferenceCode:"Weblink"'
  end

  def transform( data, ret )

    ret = super( data, ret )

    # Weblinks contain their URL in citiExtAsset
    # https://lakesolridxweb.artic.edu/solr/lpm/select?wt=json&q=legacyReferenceCode:%22Weblink%22

    ret

  end
end
