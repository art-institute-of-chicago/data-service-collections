# Model class for Artworks
class Artwork
  @@solr = RSolr.connect url: COLLECTIONS_URL

  def self.find(id)
    solr_q = 'citiUid:'.concat(id.to_s)

    # https://github.com/rsolr/rsolr
    input = @@solr.get 'select', params: {
      fq: 'hasModel:Work',
      q: solr_q,
      rows: 1,
      wt: :ruby
    }
    input = input.with_indifferent_access

    data = input[:response][:docs][0]

    # Uncomment this to see all available fields
    # return data

    _transform(data)
  end

  def self.find_all(ids, page = 1, per_page = 12)
    solr_fq = ''
    if ids
      if !ids.match('[0-9,]+')
        error!({
          error: 'Malformed Artwork IDs',
          detail: 'IDs must be a single number ID, or a list of IDs separated by commas.'
        }, 400)
      else
        ids.split(',').each do |id|
          solr_fq.concat(' OR ') if solr_fq != ''
          solr_fq.concat(id)
        end
        solr_fq = ' AND citiUid:('.concat(solr_fq).concat(')')
      end
    end
    solr_fq = 'hasModel:Work'.concat(solr_fq)

    # https://github.com/rsolr/rsolr
    input = @solr.get 'select', params: {
      fq: solr_fq,
      q: '*:*',
      sort: 'timestamp desc',
      start: (page - 1) * per_page,
      rows: per_page,
      wt: :ruby
    }
    input = input.with_indifferent_access

    # Isolate the artworks list
    data = input[:response][:docs]

    # Apply our transformation to each artwork
    data.map { |datum| _transform(datum) }
  end

  def self._transform(datas)
    if datas.is_a?(Array)
      ret = []
      datas.each do |data|
        ret.push(_transform_one(data))
      end
      return ret
    end
    _transform_one(datas)
  end

  def self._transform_one(data)
    # This allows data to use the get method
    data.extend LakeUnwrapper

    # We are aiming to use the LPM fields only, for forwards compatibility
    # Everything below the `id` field is drawn from CITI's Web Solr instance

    ret = {}
    ret[:id] = data.get(:citiUid, true, true)
    ret[:title] = data.get(:title)

    ret[:ids] = {}
    ret[:ids][:citi] = data.get(:citiUid, true, true)
    ret[:ids][:main] = data.get(:mainRefNumber)
    ret[:ids][:lake] = {}
    ret[:ids][:lake][:hid] = data.get(:uid)
    ret[:ids][:lake][:guid] = data.get(:id)
    ret[:ids][:lake][:uri] = data.get(:uri)

    ret[:titles] = {}
    ret[:titles][:raw] = data.get(:title)
    ret[:titles][:display] = data.get(:prefLabel)

    ret[:dates] = {}
    ret[:dates][:start] = data.get(:earliestYear, true, true)
    ret[:dates][:end] = data.get(:latestYear, true, true)
    ret[:dates][:display] = data.get(:dateDisplay)

    ret[:creator] = {}
    ret[:creator][:id] = data.get(:artist_uid)
    ret[:creator][:raw] = data.get(:artist)
    ret[:creator][:display] = data.get(:creatorDisplay)

    ret[:department] = {}
    ret[:department][:id] = data.get(:department_uid)
    ret[:department][:display] = data.get(:department)

    ret[:dimensions] = data.get(:dimensionsDisplay)

    ret[:medium] = {}
    ret[:medium][:raw] = data.get(:medium)
    ret[:medium][:display] = data.get(:mediumDisplay)

    ret[:inscriptions] = data.get(:title, false)
    ret[:credit_line] = data.get(:creditLine)

    ret[:history] = {}
    ret[:history][:publications] = data.get(:publicationHistory)
    ret[:history][:exhibitions] = data.get(:exhibitionHistory)
    ret[:history][:provenance] = data.get(:provenanceText)

    ret[:created_at] = data.get(:created)
    ret[:created_by] = data.get(:createdBy)
    ret[:modified_at] = data.get(:lastModified)
    ret[:modified_by] = data.get(:lastModifiedBy)

    ret
  end
end
