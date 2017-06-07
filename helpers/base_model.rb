class BaseModel

  # https://github.com/rsolr/rsolr
  cattr_accessor :fq, :solr, :page, :per_page, :env

  def initialize
    self.fq = ''
    self.solr = RSolr.connect url: COLLECTIONS_URL
    self.page = 1
    self.per_page = 12
    self.env = {
      'PATH_INFO' => '/',
      'REQUEST_URI' => 'http://localhost:9393/',
    }
  end


  # Ruby's select returns one result
  def select( q, rows )

    input = self.solr.get('select', params: {
      fq: self.fq,
      q: q,
      rows: 1,
      wt: :ruby
    }).with_indifferent_access

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

    input = self.solr.get('select', params: {
      fq: self.fq.concat( fq.to_s ),
      q: '*:*',
      sort: 'timestamp desc',
      start: (self.page - 1) * self.per_page,
      rows: self.per_page,
      wt: :ruby
    }).with_indifferent_access

    {
      "pagination": self.pagination( input ),
      "data": self.transform!( input[:response][:docs] ),
      "query": input.request[:uri].to_s.sub('wt=ruby', 'wt=json'),
    }

  end


  def find( id )
    self.select( "citiUid:#{id}", 1 )
  end


  def find_all( ids='', page=nil, per_page=nil )

    if( ids.length > 0 )
      ids = ids.split(',').join(' OR ')
      fq = " AND citiUid:(#{ids})"
    end

    if( !page.nil? && !per_page.nil? )
      self.paginate( page, per_page )
    end

    self.collect( fq )

  end


  # This should be called before any Solr query
  def paginate( env, page, per_page )
    self.env = env
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
      total: (results[:total] / results[:limit].to_f).floor + 1,
      current: (results[:offset] / results[:limit].to_f).floor + 1,
    }

    # Get base string for pagination
    path = self.env['PATH_INFO']
    host = self.env['REQUEST_URI'].split( path ).first
    base = host + path + '?'

    can_prev = self.page - 1 > 0
    can_next = self.page + 1 < pages[:total]

    links = {
      # self: env['REQUEST_URI'],
      # first: base + { :page => 1, :per_page => params[:per_page]}.to_query,
      prev: can_prev ? base + { :page => self.page - 1, :per_page => self.per_page }.to_query : nil,
      next: can_next ? base + { :page => self.page + 1, :per_page => self.per_page }.to_query : nil,
      # last:  base + { :page => pages['total'], :per_page => params[:per_page] }.to_query,
    }

    {
      "results": results,
      "pages": pages,
      "links": links,
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

    ret[:id] = data.get(:citiUid, true, true)
    ret[:title] = data.get(:title)

    ret[:ids] = {}
    ret[:ids][:citi] = data.get(:citiUid, true, true)
    ret[:ids][:lake] = {}
    ret[:ids][:lake][:uid] = data.get(:uid)
    ret[:ids][:lake][:guid] = data.get(:id, false)
    ret[:ids][:lake][:uri] = data.get(:uri, false)

    ret[:titles] = {}
    ret[:titles][:raw] = data.get(:title)
    ret[:titles][:display] = data.get(:prefLabel)

    self.transform( data, ret )

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
