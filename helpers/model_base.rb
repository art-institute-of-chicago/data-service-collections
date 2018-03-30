class BaseModel

  # https://github.com/rsolr/rsolr
  cattr_accessor :fq, :solr, :page, :per_page, :url, :extra_params

  def initialize
    self.fq = ''
    self.solr = RSolr.connect url: COLLECTIONS_URL
    self.page = 1
    self.per_page = 12
    self.url = 'http://localhost:9393/'
    self.extra_params = {}
  end


  # Ruby's select returns one result
  def select( q, rows )

    input = self.solr.get('select', params: {
      fq: self.fq,
      q: q,
      rows: 1,
      wt: :ruby
    }.merge(self.extra_params)).with_indifferent_access

    if input[:response][:numFound] < 1
      return false
    end

    {
      "data": self.transform!( input[:response][:docs][0] ),
      "query": input.request[:uri].to_s.sub('wt=ruby', 'wt=json'),
    }

  end


  # Ruby's collect returns all results
  def collect( fq = '' )

    input = self.collect_get_query( fq )

    {
      "pagination": self.pagination( input ),
      "data": self.transform!( input[:response][:docs] ),
      "query": input.request[:uri].to_s.sub('wt=ruby', 'wt=json'),
    }

  end

  def collect_get_query( fq = '' )

    self.solr.get('select', params: {
      fq: self.fq.concat( fq.to_s ),
      q: '*:*',
      sort: 'timestamp desc',
      start: (self.page - 1) * self.per_page,
      rows: self.per_page,
      wt: :ruby
    }.merge(self.extra_params)).with_indifferent_access

  end

  def find( id )

    if id.include? '-'
      self.select( "id:#{id}", 1 )
    else
      self.select( "citiUid:#{id}", 1 )
    end

  end


  def find_all( ids='', page=nil, per_page=nil )

    fq = ''

    if( ids.length > 0 )

      ids = ids.split(',')

      citi_ids = []
      lake_ids = []

      ids.each { |id|

        if id.include? '-'
          lake_ids.push( id )
        else
          citi_ids.push( id )
        end

      }

      citi_ids = citi_ids.join(' OR ')
      lake_ids = lake_ids.join(' OR ')

      # Assumes the model has an existing `fq`
      fq << " AND"

      fq << " ("

      if citi_ids.length > 0
        fq << " citiUid:(#{citi_ids})"
      end

      if citi_ids.length > 0 and lake_ids.length > 0
        fq << " OR"
      end

      if lake_ids.length > 0
        fq << " id:(#{lake_ids})"
      end

      fq << " )"

    end

    if( !page.nil? && !per_page.nil? )
      self.paginate( page, per_page )
    end

    self.collect( fq )

  end


  # This should be called before any Solr query
  def paginate( url, page, per_page )
    self.url = url
    self.page = page
    self.per_page = per_page
  end


  def pagination( input )

    # http://ruby-doc.org/core-2.0.0/Hash.html
    results = {
      count: input[:response][:docs].length,
      total: input[:response][:numFound],
      limit: input[:responseHeader][:params][:rows].to_i,
      offset: input[:response][:start],
    }

    pages = {
      total: (results[:total] / results[:limit].to_f).ceil,
      current: (results[:offset] / results[:limit].to_f).floor + 1,
    }

    # Get base string for pagination
    base = self.url
    base = base.gsub(/\?.*/, '') + '?'

    # Pages are 1-indexed
    can_prev = self.page - 1 > 0
    can_next = self.page + 1 <= pages[:total]

    links = {
      # self: self.url,
      # first: base + { :page => 1, :per_page => params[:per_page]}.to_query,
      prev: can_prev ? base + { :page => self.page - 1, :limit => self.per_page }.to_query : nil,
      next: can_next ? base + { :page => self.page + 1, :limit => self.per_page }.to_query : nil,
      # last:  base + { :page => pages['total'], :per_page => params[:per_page] }.to_query,
    }

    {
      "total": results[:total],
      "limit": results[:limit],
      "offset": results[:offset],
      "total_pages": pages[:total],
      "current_page": pages[:current],
      "prev_url": links[:prev],
      "next_url": links[:next],
    }

  end

  # Transform array or object - don't override this!
  def transform!( data )

    if data.is_a?(Array)
      return data.map { |datum| _transform( datum ) }
    end

    # This'll take effect if data is not an array
    _transform( data )

  end

  # Private helper function, disregard
  def _transform( data )

    # We are aiming to use the LPM fields only, for forwards compatibility
    # Everything below the `id` field is drawn from CITI's Web Solr instance

    # This allows data to use the get method
    data.extend LakeUnwrapper

    # Defining this here allows us to set some common fields
    ret = {}

    # Not all resources will have a citiUid, but it is cannonical for most entities
    ret[:id] = Integer( data.get(:citiUid) ) rescue nil
    ret[:title] = data.get(:title)
    ret[:citi_id] = Integer( data.get(:citiUid) ) rescue nil
    ret[:lake_guid] = data.get(:id, false)
    ret[:lake_uri] = data.get(:uri, false)
    ret[:lake_uid] = data.get(:uid)

    self.transform( data, ret )

    # TODO: This date is too precise. Carbon complains about trailing data.
    ret[:citi_created_at] = nil # data.get(:citiCreateDate, false) # absent
    ret[:citi_modified_at] = nil # data.get(:citiUpdateDate, false)

    ret[:created_at] = data.get(:created)
    ret[:modified_at] = data.get(:lastModified)
    ret[:indexed_at] = data.get(:timestamp, false)

    ret

  end


  # Override this in subclass!
  # Operates on a single datum
  def transform( data, ret )

    ret

  end

end
