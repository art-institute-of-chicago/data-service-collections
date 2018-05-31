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
      r[:route]         = model.name.pluralize.underscore.dasherize.to_sym

      resource r[:route] do

        desc "Return an #{r[:entity]}"
        params do
          requires :id, desc: 'CITI ID or LAKE GUID', regexp: /^
            # match integer or guid
            (?:[\-0-9]+|[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12})
          $/x
        end
        route_param :id do
          get do

            entity = r[:model].new.find( params[:id] )

            # Abort if no results
            error!({
              error: "#{r[:entity]} not found",
              detail: "#{r[:entity]} does not exist in LPM Solr. Ensure you are passing the CITI ID or LAKE GUID."
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
          optional :per_page, type: Integer
          optional :limit, type: Integer
          optional :fli, type: String # inbound key filter (Solr)
          optional :flo, type: String # outbound key fiter (to DA)
          optional :ids, type: String, default: '', regexp: /(?:^|,)
          (?:
              [\-0-9]+|                                                    # integers
              [A-Z]{2}-[0-9]+|                                             # OR uids
              [0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12} # OR UUIDs
          )*
          (?=,|$)/xi
          optional :fields, type: String, default: '', regexp: /(?:^|,)
          (?:
              [a-zA-Z_]
          )*
          (?=,|$)/xi
        end
        get do

          model = r[:model].new

          model.paginate(
            request.url,
            params.fetch(:page, 1),
            params.fetch(:per_page, nil) || params.fetch(:limit, 12)
          )

          if not params.fetch(:fli, nil).nil?
            model.extra_params = { :fl => params.fetch(:fli) }
          end

          ret = model.find_all(
            params.fetch(:ids, ''),
          )

          if not params.fetch(:flo, nil).nil?
            fields = params.fetch(:flo).split(',')
            ret[:data].map! { |datum| datum.delete_if { |key, value| !fields.include? key.to_s } }
          end

          ret

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
    self.addResource( Agent )
    self.addResource( Artist )
    self.addResource( Place )
    self.addResource( Gallery )
    self.addResource( Exhibition )
    self.addResource( Department )
    self.addResource( Category )
    self.addResource( AgentType )
    self.addResource( Curriculum )
    self.addResource( GradeLevel )
    self.addResource( ObjectType )

    # Assets
    self.addResource( Sound )
    self.addResource( Video )
    self.addResource( Text )
    self.addResource( Link )
    self.addResource( Image )

    # Artwork-to-Foobar pivot models
    self.addResource( ArtworkAgent )
    self.addResource( ArtworkCatalogue )
    self.addResource( ArtworkDate )
    self.addResource( ArtworkPlace )

    self.addResource( ArtworkAgentRole )
    self.addResource( ArtworkDateQualifier )
    self.addResource( ArtworkPlaceQualifier )
    self.addResource( AgentPlaceQualifier )

    self.addResource( Catalogue )
    self.addResource( Group )
    self.addResource( Term )
    self.addResource( TermType )

    # Exhibition-to-Foobar pivot models
    self.addResource( ExhibitionAgent )
    self.addResource( ExhibitionArtwork )

    # Agent-to-Foobar pivot models
    self.addResource( AgentPlace )
    self.addResource( AgentType )

    # List of deleted models
    self.addResource( Delete )

    # Throw a 404 for all undefined endpoints
    route :any, '*path' do
      error!({
        error: 'Endpoint not found',
        detail: 'The endpoint you are requesting cannot be found'
      }, 404)
    end


  end
end
