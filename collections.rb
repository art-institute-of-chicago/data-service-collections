require 'grape'
require 'rsolr'
require './conf.rb'

# Sample calls:
#   http://localhost:9292/v1/artworks/111628
#   http://localhost:9292/v1/artworks/111629
#   http://localhost:9292/v1/artworks/60622 (missing history fields)

module Collections

  module LakeUnwrapper
    def get( key, unwrap = true, int = false)

      return nil if !self.key?(key)

      out = self[key]

      out = out[0] if unwrap

      out = out.to_i if int

      return out

    end
  end

  module ErrorFormatter
    def self.call(message, backtrace, options, env)
      {
        # TODO: At some point we can add an :id representing the unique instance of an error
        # and a :code represneting our own convention of identifying errors
        :status => env[Grape::Env::API_ENDPOINT].status,
        :error => (message.is_a? String) ? message : message[:error],
        :detail => (message.is_a? String) ? nil : message[:detail],
      }.to_json
    end
  end
    
  class API < Grape::API
    version 'v1'
    format :json
    error_formatter :json, Collections::ErrorFormatter
    
    before do
      @solr = RSolr.connect :url => COLLECTIONS_URL
    end

    resource :artworks do
      desc 'Return an artwork'
      params do
        requires :id, type: Integer, desc: 'Artwork ID'
      end
      route_param :id do
        get do
          solr_q = 'citiUid:'.concat(params[:id].to_s)
        
          # https://github.com/rsolr/rsolr
          input = @solr.get 'select', params: {
            fq: 'hasModel:Work',
            q: solr_q,
            rows: 1,
            wt: :ruby
          }
          input = input.with_indifferent_access
          
          # Abort if no results
          if input[:response][:numFound] < 1
            error!({
              error: 'Artwork not found',
              detail: 'Artwork does not exist in LPM Solr. Ensure you are passing the CITI ID.'
            }, 404)
          end

          data = input[:response][:docs][0]

          # Uncomment this to see all available fields
          # return datas

          {
            "data" => API.transform(data)
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

        solr_fq = ''
        if params[:ids]
          if !params[:ids].match('[0-9,]+')
            error!({
              error: 'Malformed Artwork IDs',
              detail: 'IDs must be a single number ID, or a list of IDs separated by commas.'
            }, 400)
          else
            params[:ids].split(',').each do |id|
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
            start: (params.fetch(:page, 1) - 1) * params.fetch(:per_page, 12),
            rows: params.fetch(:per_page, 12),
            wt: :ruby,
          }
          input = input.with_indifferent_access

          # Isolate the artworks list
          data = input[:response][:docs]

          # Apply our transformation to each artwork
          data = data.map { |datum| API.transform(datum) }


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

    def self.transform(datas)
      if datas.kind_of?(Array)
        ret = []
        datas.each do |data|
          ret.push(self._transform(data))
        end
        return ret
      end
      self._transform(datas)
    end

    def self._transform(data)
      # This allows data to use the get method
      data.extend LakeUnwrapper

      # We are aiming to use the LPM fields only, for forwards compatibility
      # Everything below the `id` field is drawn from CITI's Web Solr instance

      {
        "id": data.get("citiUid", true, true),
        "title": data.get("title"),
        "ids": {
          "citi": data.get("citiUid", true, true),
          "main": data.get("mainRefNumber"),
          "lake": {
            "hid": data.get("uid"),
            "guid": data.get("id", false),
            "batch": data.get("batchUid"),
            "uri": data.get("uri", false),
          },
        },
        "titles": {
          "raw": data.get("title"),
          "display": data.get("prefLabel"),
        },
        "dates": {
          "start": data.get("earliestYear", true, true),
          "end": data.get("latestYear", true, true),
          "display": data.get("dateDisplay"),
        },
        "creator": {
          "id": data.get("artist_uid"),
          "raw": data.get("artist"),
          "display": data.get("creatorDisplay"),
        },
        "department": {
          "id": data.get("department_uid"),
          "display": data.get("department"),
        },
        "dimensions": data.get("dimensionsDisplay"),
        "medium": {
          "raw": data.get("medium"),
          "display": data.get("mediumDisplay"),
        },
        "inscriptions": data.get("title", false),
        "credit_line": data.get("creditLine"),
        "history": {
          "publications": data.get("publicationHistory"),
          "exhibitions": data.get("exhibitionHistory"),
          "provenance": data.get("provenanceText"),
        },
        "created_at": data.get("created"),
        "created_by": data.get("createdBy"),
        "modified_at": data.get("lastModified"),
        "modified_by": data.get("lastModifiedBy"),
      }
    end
  end
end
