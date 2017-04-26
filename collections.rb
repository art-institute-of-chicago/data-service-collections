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
      desc 'Return a few artworks.'
      params do
        requires :ids, type: String, desc: 'Artwork IDs'
      end
      route_param :ids do
        get do
          
          if '[0-9,]+'.match(params[:ids].to_s)
            error!({
              error: 'Malformed Artwork IDs',
              detail: 'IDs must be a single number ID, or a list of IDs separated by commas.'
            }, 400)
          end

          solr_q = ''
          params[:ids].split(',').each do |id|
            if solr_q != ''
              solr_q.concat(' OR ')
            end
            solr_q.concat(id)
          end
          solr_q = 'citiUid:('.concat(solr_q).concat(')')
        
          # https://github.com/rsolr/rsolr
          input = @solr.get 'select', params: {
            fq: 'hasModel:Work AND '.concat(solr_q),
            q: '*:*',
            rows: 1000,
            wt: :ruby
          }
        
          # Abort if no results
          if input["response"]["numFound"] < 1
            error!({
              error: 'Artwork not found',
              detail: 'Artwork does not exist in LPM Solr. Ensure you are passing the CITI ID.'
            }, 404)
          end

          datas = input["response"]["docs"]

          # Uncomment this to see all available fields
          # return datas

          {
            "data": API.transform(datas)
          }
        end
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
