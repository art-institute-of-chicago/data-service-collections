# Navigate LAKE Solr data
module LakeUnwrapper
  def get(key, unwrap = true)
    key = key.to_s
    return nil unless key?(key)
    out = self[key]
    out = out[0] if unwrap
    if out.kind_of?(String)
      out = nil if out.empty?
    end
    if out.kind_of?(Array)
      out = out.map { |n| n.empty? ? nil : n }
      out = nil if !out.any?
    end
    out
  end
  def json(key)
      json = self.get(key, false)
      json = json.gsub("\r", '') # cf. 51417
      json = JSON.parse(json) rescue {}
      json = json.select{ |item| item["restricted"] == 0 }
      json
  end
end
