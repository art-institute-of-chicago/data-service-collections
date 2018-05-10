class ResourceModel < BaseModel

  def initialize
    super
    # All interpretive resources imported from CITI have `General` for documentType_uri
    # We don't actually want to filter by it, since e.g. not all sounds are interpretive resources
    # We also don't know how IRs entered through LAKE will be tagged as such.
    # self.fq = 'documentType_uri:http://definitions.artic.edu/doctypes/General'
    # self.fq << ' AND type:http://definitions.artic.edu/ontology/1.0/type/Sound'
  end

  def getDescription( data )

    # Most times, description contains only one item.
    # However, sometimes, description contains two items:
    #  in the 1st item, tags are seperated by spaces; in 2nd, by \n
    # We want the 2nd one - easier to parse into Markdown, etc.

    value = data.get(:description, false)

    if value == nil || !value.kind_of?(Array)
      return value
    end

    if value.length > 1
      return value[1]
    end

    return value[0]

  end

  def getContent( data )

    # TODO: Retrieve files from the LPM Repository
    return data.get(:citiExtAsset) || data.get(:legacyContent, false) || nil

  end

  def transform( data, ret )

    # For assets, we want the cannonical id to be the LAKE GUID, not the CITI ID
    ret[:id] = ret[:lake_guid]

    # Keep the lake_guid field too, for clarity
    # ret.delete(:lake_guid)


    # In addition to the BaseModel API fields, all interpretive resources share the following fields:

    ret[:description] = getDescription( data )

    # The `content` field contains the "meat" of the resource.
    # Typically this is a link, either to a file, or to another webpage.
    # For texts, it's the HTML or plaintext partial.

    ret[:content] = getContent( data )


    # TODO: Determine if we need the other publication channels
    ret[:published] = data.get(:legacyIsCollectionsWebPublished, false) == "True" ? true : false;

    # There is no artwork_uid or anything equivallent:
    # Resources report their related artist, but an artwork's
    #   relationship to a resource is reported on the artwork side

    ret[:artist_id] = str2int( data.get(:artist_uid) )

    ret[:category_guids] = Uri2Guid( data.get(:publishCategory, false) )

    ret[:attached_to_asset_id] = Uri2Guid( data.get(:isAttachmentOf_uri) )

    ret[:copyright_representative_id] = str2int( data.get(:copyrightRepresentative_uid) )

    ret[:alt_text] = data.get(:visualSurrogate, false)

    # Omitting for now, but revisit later, when they are GUIDs or URIs:
    # legacyCurriculum
    # legacyGradeLevel

    # Ignore all fields below this line:

    # The next two fields were part of "Art Explorer" (retired into Educational Resources in 2012)
    # http://www.artic.edu/aic/resources/resource/2412

    # legacyAudienceFrom: 0, 1, 2, 3, 4, 5, 6, 7, 9
    # legacyAudienceTo: 0, 12, 13, 14, 3, 6, 8, 9,

    # legacyIsEduPortalPublished
    # legacyIsMultimediaPortalPublished
    # legacyIsCollectionsWebPublished

    # legacyAssetType -> e.g. Image, Text, PDF, Map (Google)
    # https://lakesolridxweb.artic.edu/solr/lpm/select?wt=json&facet.field=legacyAssetType&rows=0

    # legacyFileFormatUid -> see CITI -> Enter -> List Editor -> File Formats
    # https://lakesolridxweb.artic.edu/solr/lpm/select?wt=json&facet.limit=-1&rows=0&facet.field=legacyFileFormatUid
    # LAKE is gonna have its own way to manage formats and other metadata. Ignore for now.

    # legacyResourceType
    # https://lakesolridxweb.artic.edu/solr/lpm/select?wt=json&rows=0&facet.field=legacyResourceType

    # legacyReferenceCode -> attached file, embedded code?, html/text as content, weblink, youtube video id
    # https://lakesolridxweb.artic.edu/solr/lpm/select?wt=json&facet.limit=-1&rows=0&facet.field=legacyReferenceCode

    # Ignore embedded code type: the only one present is a test
    # https://lakesolridxweb.artic.edu/solr/lpm/select?wt=json&q=legacyReferenceCode:%22Embedded%20Code%22

    ret

  end

end
