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

          return artwork

        end
      end

      desc 'Return all artworks, paginated, descending timestamp.'
      params do
        optional :page, type: Integer, default: 1
        optional :per_page, type: Integer, default: 12
        optional :ids, type: String
      end
      get do

        Artwork.paginate(
          env,
          params.fetch(:page, 1),
          params.fetch(:per_page, 12),
        )

        Artwork.find_all(
          params.fetch(:ids, ''),
        )

      end

      # Throw a 404 for all undefined endpoints
      route :any, '*path' do
        error! # or something else
      end
    end

  end
end

