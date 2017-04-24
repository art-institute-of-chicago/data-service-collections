require 'grape'
require 'rsolr'
require './conf.rb'

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

          output = {
            "ids": {
              "citi": data["citiUid"][0].to_i,
              "main": data["mainRefNumber"][0],
              "lake": {
                "hid": data["uid"][0],
                "guid": data["id"],
                "batch": data["batchUid"][0],
                "uri": data["uri"],
              },
            },
            "title": {
              "raw": data["title"][0],
              "display": data["prefLabel"][0],
            },
            "dates": {
              "start": data["earliestYear"][0].to_i,
              "end": data["latestYear"][0].to_i,
              "display": data["dateDisplay"][0],
            },
            "department": {
              "id": data["department_uid"][0],
              "display": data["department"][0],
            },
            "creator": {
              "id": data["artist_uid"][0],
              "raw": data["artist"][0],
              "display": data["creatorDisplay"][0],
            },
            "dimensions": data["dimensionsDisplay"][0],
            "medium": {
              "raw": data["medium"][0],
              "display": data["mediumDisplay"][0],
            },
            "inscriptions": data["inscriptions"],
            "credit_line": data["creditLine"][0],
            "history": {
              "publications": data["publicationHistory"][0],
              "exhibitions": data["exhibitionHistory"][0],
              "provenance": data["provenanceText"][0],
            },
            "created_at": data["created"][0],
            "created_by": data["createdBy"][0],
            "modified_at": data["lastModified"][0],
            "modified_by": data["lastModifiedBy"][0],
          }

        end
      end
    end
  end
end
