class BaseModel

  # https://github.com/rsolr/rsolr
  @@solr = RSolr.connect url: COLLECTIONS_URL
  @@fq = ''

  @@page = 1
  @@per_page = 12

  @@env = {
    'PATH_INFO' => '/',
    'REQUEST_URI' => 'http://localhost:9393/',
  }

  # Ruby's select returns one result
  def self.select( q, rows )

    input = @@solr.get('select', params: {
      fq: @@fq,
      q: q,
      rows: 1,
      wt: :ruby
    }).with_indifferent_access

    if input[:response][:numFound] < 1
      return false
    end

    {
      "data": self.transform!( input[:response][:docs][0] ),
    }

  end


  # Ruby's collect returns all results
  def self.collect( fq = '' )

    input = @@solr.get('select', params: {
      fq: @@fq.concat( fq.to_s ),
      q: '*:*',
      sort: 'timestamp desc',
      start: (@@page - 1) * @@per_page,
      rows: @@per_page,
      wt: :ruby
    }).with_indifferent_access

    {
      "pagination": self.pagination( input ),
      "data": self.transform!( input[:response][:docs] ),
    }

  end


  def self.find( id )
    self.select( "citiUid:#{id}", 1 )
  end


  def self.find_all( ids='', page=nil, per_page=nil )

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
  def self.paginate( env, page, per_page )
    @@env = env
    @@page = page
    @@per_page = per_page
  end


  def self.pagination( input )

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
    path = @@env['PATH_INFO']
    host = @@env['REQUEST_URI'].split( path ).first
    base = host + path + '?'

    can_prev = @@page - 1 > 0
    can_next = @@page + 1 < pages[:total]

    links = {
      # self: env['REQUEST_URI'],
      # first: base + { :page => 1, :per_page => params[:per_page]}.to_query,
      prev: can_prev ? base + { :page => @@page - 1, :per_page => @@per_page }.to_query : nil,
      next: can_next ? base + { :page => @@page + 1, :per_page => @@per_page }.to_query : nil,
      # last:  base + { :page => pages['total'], :per_page => params[:per_page] }.to_query,
    }

    {
      "results": results,
      "pages": pages,
      "links": links,
    }

  end

  # Transform array or object - don't override this!
  def self.transform!( data )

    if data.is_a?(Array)
      return data.map { |datum| _transform( datum ) }
    end

    # This'll take effect if data is not an array
    _transform( data )

  end

  # Private helper function, disregard
  def self._transform( datum )

    # This allows data to use the get method
    datum.extend LakeUnwrapper
    self.transform( datum )

  end


  # Override this in subclass!
  def self.transform( datum )



    datum

  end


end
