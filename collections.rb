require 'conf.rb'

module Collections
  class API < Grape::API
    version 'v1'
    format :json
    prefix :api

    def solr
      @solr
    end

    def solr=(str)
      @solr = str
    end
  
    before do
      @solr = RSolr.connect :url => COLLECTIONS_URL
    end

    resource :statuses do
      desc 'Return an artwork.'
      params do
        requires :id, type: Integer, desc: 'Artwork ID.'
      end
      route_param :id do
        get do
          response = @solr.get 'select', params: { fq: 'hasModel:Work',
                                                   q: 'citiUid:' + params[:id],
                                                   rows: 1,
                                                   wt: :ruby }
          json response['response']['docs'][0]
        end
      end
    end
  end
end
