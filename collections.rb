require_relative 'config/app.rb'

# Sample calls:
#   http://localhost:9292/v1/artworks/111628
#   http://localhost:9292/v1/artworks/111629
#   http://localhost:9292/v1/artworks/60622 (missing history fields)

module Collections
  class API < Grape::API
    version 'v1'
    format :json
    content_type :json, 'application/json; charset=utf-8'
    error_formatter :json, ErrorFormatter


    # These routes will be applied to all models
    def self.addResource( model )

      r = Hash.new;

      r[:model]         = model
      r[:entity]        = model.name
      r[:entities]      = model.name.pluralize
      r[:route]         = model.name.pluralize.downcase.to_sym

      resource r[:route] do

        desc "Return an #{r[:entity]}"
        params do
          requires :id, type: Integer, desc: 'CITI ID'
        end
        route_param :id do
          get do

            entity = r[:model].new.find( params[:id] )

            puts entity

            # Abort if no results
            error!({
              error: "#{r[:entity]} not found",
              detail: "#{r[:entity]} does not exist in LPM Solr. Ensure you are passing the CITI ID."
            }, 404) if (!entity)

            return entity

          end
          route :any do
            error!({
              error: "Method not allowed",
              detail: "You may only GET #{r[:entities]}. No other method is allowed."
            }, 405)
          end
        end

        desc "Return all #{r[:entities]}, paginated, descending timestamp."
        params do
          optional :page, type: Integer, default: 1
          optional :per_page, type: Integer, default: 12
          optional :ids, type: String, default: '', regexp: /[0-9,]*/
        end
        get do

          model = r[:model].new

          model.paginate(
            env,
            params.fetch(:page, 1),
            params.fetch(:per_page, 12),
          )

          model.find_all(
            params.fetch(:ids, ''),
          )

        end
        route :any do
          error!({
            error: "Method not allowed",
            detail: "You may only GET #{r[:entities]}. No other method is allowed."
          }, 405)
        end

      end

    end


    self.addResource( Artwork )


    self.addResource( Artist  )


    self.addResource( Gallery )


    self.addResource( Department )


    self.addResource( Theme )


    self.addResource( AgentType )


    # Throw a 404 for all undefined endpoints
    route :any, '*path' do
      error!({
        error: 'Endpoint not found',
        detail: 'The endpoint you are requesting cannot be found'
      }, 404)
    end


  end
end

