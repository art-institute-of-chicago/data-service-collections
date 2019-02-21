require "net/http"
require "uri"

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

  def getRels( relation_ids, is_preferred, is_doc )

    {
      :artworks => relation_ids.select { |i| i.start_with? 'WO-' },
      :exhibitions => relation_ids.select { |i| i.start_with? 'EX-' }
    }.each do |relation, ids|
      id_key = (relation.to_s.singularize + '_id').to_sym
      ids.map! do |id|
        {
          id_key => str2int(id),
          :is_preferred => is_preferred,
          :is_doc => is_doc,
        }
      end
    end

  end

  def getContent( data )

    # We are going to assume that any pdf, mp3, or wav has

    # LAKE's "External Content" fields - this only grabs the first one!
    ret = data.get(:externalContent) || nil

    if ret == nil && !(data.get(:type, false).include? 'http://definitions.artic.edu/ontology/1.0/type/StillImage')
      uri_raw = 'https://lakeimagesweb.artic.edu/assets/' + data.get(:id, false)
      uri = URI.parse(uri_raw)

      response = nil
      Net::HTTP.start(uri.host, 443, :use_ssl => true) {|http|
        response = http.head(uri.path)
      }

      if response.kind_of? Net::HTTPSuccess
        ret = uri_raw
      end
    end

    ret

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

    # Not used widely; there's a push to move these to artworks
    ret[:alt_text] = data.get(:visualSurrogate)

    ret[:is_educational_resource] = (data.get(:publishChannel, false).include? 'http://definitions.artic.edu/publish_channel/EducationalResources' rescue nil) || false
    ret[:is_multimedia_resource] = (data.get(:publishChannel, false).include? 'http://definitions.artic.edu/publish_channel/Multimedia' rescue nil) || false
    ret[:is_teacher_resource] = (data.get(:publishChannel, false).include? 'http://definitions.artic.edu/publish_channel/TeacherResources' rescue nil) || false

    # ret[:is_attachment_of_ids] = str2int( data.get(:isAttachmentOfUid_uid, false) )
    # ret[:has_attachment_of_ids] = str2int( data.get(:hasAttachmentOfUid_uid, false) )
    ret[:is_attachment_of_ids] = Uri2Guid( data.get(:isAttachmentOf_uri) )

    # New fields for relationship flip:
    doc_of_uids = data.get(:isDocumentOfUid_uid, false) || []

    docs = getRels(doc_of_uids, false, true)

    ret[:doc_of_artworks] = docs[:artworks]
    ret[:doc_of_exhibitions] = docs[:exhibitions]

    ret[:rep_of_artworks] = []
    ret[:rep_of_exhibitions] = []

    # Uncomment for debug:
    # ret[:is_doc_of_ids] = doc_of_uids

    # Ignore all fields below this line:

    # The next two fields were part of "Art Explorer" (retired into Educational Resources in 2012)
    # http://www.artic.edu/aic/resources/resource/2412

    # legacyAudienceFrom: 0, 1, 2, 3, 4, 5, 6, 7, 9
    # legacyAudienceTo: 0, 12, 13, 14, 3, 6, 8, 9,

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
