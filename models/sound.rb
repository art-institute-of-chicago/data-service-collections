class Sound < ResourceModel

  def initialize
    super
    self.fq = 'type:"http://definitions.artic.edu/ontology/1.0/type/Sound"'
    # We are getting all sounds, not just interpretive resources
    # self.fq << ' AND documentType_uri:http://definitions.artic.edu/doctypes/General'
  end

  def transform( data, ret )

    ret = super( data, ret )

    # TODO: Derive type of sound from the `documentType_uri` field?
    # https://lakesolridxweb.artic.edu/solr/lpm/select?wt=json&rows=0&facet.field=documentType_uri

    # http://definitions.artic.edu/doctypes/DESound = audio tours
    # http://definitions.artic.edu/doctypes/General = IR imported from CITI - podcasts and interviews

    # legacyFileFormatUid -> whole bunch, not sure what's to be done w/ it all... MIME type?
    # https://lakesolridxweb.artic.edu/solr/lpm/select?wt=json&facet.limit=-1&rows=0&facet.field=legacyFileFormatUid

    ret

  end
end
