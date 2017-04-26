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

  class API < Grape::API
    version 'v1'
    format :json

    before do
      @solr = RSolr.connect :url => COLLECTIONS_URL
    end

    resource :artworks do

      desc 'Return all artworks, paginated, descending timestamp.'
      params do
        optional :page, type: Integer, default: 1
        optional :per_page, type: Integer, default: 12
      end
      get do

          # TODO: Accept params
          # Retrieve `start` and `rows` from params
          # Assume start=0 and rows=12 if absent

          # https://github.com/rsolr/rsolr
          input = @solr.get 'select', params: {
            fq: 'hasModel:Work',
            sort: 'timestamp desc',
            rows: 12,
            wt: :ruby,
          }

          # Isolate the artworks list
          data = input["response"]["docs"]

          # Apply our transformation to each artwork
          data = data.map { |datum| API.transform(datum) }

          # Some pagination calculation...
          # http://ruby-doc.org/core-2.0.0/Hash.html
          results = {
            count: input["response"]["numFound"],
            limit: input["responseHeader"]["params"]["rows"].to_i,
            offset: input["response"]["start"],
          }

          pages = {
            total: (results[:count].to_f / results[:limit].to_f).floor + 1,
            current: (results[:offset].to_f / results[:limit].to_f).floor + 1,
            # TODO: next_page
            # TODO: prev_page
          }

          {
            "pagination": {
              "results": results,
              "pages": pages
            },
            "data": data
          }

      end

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

          # Abort if no results
          if input["response"]["numFound"] < 1
            error!({
              error: 'Artwork not found',
              detail: 'Artwork does not exist in LPM Solr. Ensure you are passing the CITI ID.'
            }, 404)
          end

          # Jumping to the results for brevity... we only care about the first one.
          # If more than one result was returned for this route, something went wrong.
          data = input["response"]["docs"][0]

          # Uncomment this to see all available fields
          # return data

          {
            "data": API.transform(data)
          }

        end
      end
    end

    def self.transform(data)

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
