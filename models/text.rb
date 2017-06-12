class Text < ResourceModel

  def initialize
    super
    self.fq = 'legacyReferenceCode:"HTML/Text as Content"'
  end

  def transform( data, ret )

    ret = super( data, ret )

    # legacyContent contains data for "HTML/Text is Content"
    # https://lakesolridxweb.artic.edu/solr/lpm/select?wt=json&q=legacyReferenceCode:%22HTML/Text%20as%20Content%22&fl=legacyContent
    # Some of it is coming from the closer app? http://www.artic.edu/aic/resources/resource/3022

    ret

  end
end
