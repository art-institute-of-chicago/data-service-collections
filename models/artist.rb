class Artist < BaseModel

  def initialize
    super
    self.extra_params = { :fl => "null", :facet => true, 'facet.field' => 'artist_uid', 'facet.limit' => -1 }
  end

  def collect( fq = '' )

    super

    input = self.collect_get_query( 'hasModel:Work' )

    a = input[:facet_counts][:facet_fields][:artist_uid]
    uids = a.values_at(* a.each_index.select {|i| i.even?})

    citi_pkeys = []
    uids.each do |uid|
      citi_pkeys.push(uid[3..-1])
    end

    {
      "data": citi_pkeys,
      "query": input.request[:uri].to_s.sub('wt=ruby', 'wt=json'),
    }

  end

  def transform( data, ret )

    ret[:date_birth] = data.get(:birthDate) ? Integer( Date.parse( data.get(:birthDate) ).strftime('%Y') ) : nil
    ret[:date_death] = data.get(:deathDate) ? Integer( Date.parse( data.get(:deathDate) ).strftime('%Y') ) : nil

    ret

  end
end
