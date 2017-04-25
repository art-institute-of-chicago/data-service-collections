require 'grape'
require 'rsolr'
require './conf.rb'

# Sample calls:
#   http://localhost:9292/v1/artworks/111628
#   http://localhost:9292/v1/artworks/111629
#   http://localhost:9292/v1/artworks/60622 (missing history fields)

module Collections
  class API < Grape::API
    version 'v1'
    format :json

    before do
      @solr = RSolr.connect :url => COLLECTIONS_URL
    end

    resource :artworks do
      desc 'Return an artwork.'
      params do
        requires :id, type: Integer, desc: 'Artwork ID.'
      end
      route_param :id do
        get do

          # https://github.com/rsolr/rsolr
          input = @solr.get 'select', params: {
            fq: 'hasModel:Work',
            q: 'citiUid:' + params[:id].to_s,
            rows: 1,
            wt: :ruby
          }

          data = input["response"]["docs"][0]

          # Uncomment this to see all available fields
          # We are aiming to use the LPM fields only, for forwards compatibility
          # Everything below the `id` field is drawn from CITI's Web Solr instance
          # return data

          def data.get( key, unwrap = true, int = false)

            if !self.key?(key)
              return nil
            end

            out = self[key]

            if unwrap
              out = out[0]
            end

            if int
              out = out.to_i
            end

            return out

          end

          output = {
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
            "title": {
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
  end
end
