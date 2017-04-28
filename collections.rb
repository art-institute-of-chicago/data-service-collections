require_relative 'config/app.rb'

# Sample calls:
#   http://localhost:9292/v1/artworks/111628
#   http://localhost:9292/v1/artworks/111629
#   http://localhost:9292/v1/artworks/60622 (missing history fields)

module Collections
  class API < Grape::API
    version 'v1'
    format :json
    error_formatter :json, ErrorFormatter

    @@solr = RSolr.connect url: COLLECTIONS_URL

    resource :artworks do

      desc 'Return an artwork'
      params do
        requires :id, type: Integer, desc: 'Artwork ID'
      end
      route_param :id do
        get do

          artwork = Artwork.find(params[:id])

          # Abort if no results
          error!({
            error: 'Artwork not found',
            detail: 'Artwork does not exist in LPM Solr. Ensure you are passing the CITI ID.'
          }, 404) if (!artwork)

          {
            :data => artwork
          }
        end
      end

      desc 'Return all artworks, paginated, descending timestamp.'
      params do
        optional :page, type: Integer, default: 1
        optional :per_page, type: Integer, default: 12
        optional :ids, type: String
      end
      get do

        # TODO: Accept params
        # Retrieve `start` and `rows` from params
        # Assume start=0 and rows=12 if absent

        artworks = Artwork.find_all(params[:ids], params.fetch(:page, 1), params.fetch(:per_page, 12))

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
        path = env['PATH_INFO']
        host = env['REQUEST_URI'].split( path ).first
        base = host + path + '?'

        can_prev = params.fetch(:page, 1) - 1 > 0
        can_next = params.fetch(:page, 1) + 1 < pages[:total]

        links = {
          # self: env['REQUEST_URI'],
          # first: base + { :page => 1, :per_page => params[:per_page]}.to_query,
          prev: can_prev ? base + { :page => (params[:page] || 1) - 1, :per_page => params[:per_page] }.to_query : nil,
          next: can_next ? base + { :page => (params[:page] || 1) + 1, :per_page => params[:per_page] }.to_query : nil,
          # last:  base + { :page => pages['total'], :per_page => params[:per_page] }.to_query,
        }

        {
          "pagination": {
            "results": results,
            "pages": pages,
            "links": links,
          },
          "data": data
        }

      end

      # Throw a 404 for all undefined endpoints
      route :any, '*path' do
        error! # or something else
      end
    end

  end
end
