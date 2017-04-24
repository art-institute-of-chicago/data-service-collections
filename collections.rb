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
          @solr.get 'select', params: { fq: 'hasModel:Work',
                                        q: 'citiUid:' + params[:id].to_s,
                                        rows: 1,
                                        wt: :ruby }
        end
      end
    end
  end
end
