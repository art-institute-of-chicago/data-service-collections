# Navigate LAKE Solr data
module LakeUnwrapper
  def get(key, unwrap = true)
    key = key.to_s
    return nil unless key?(key)
    out = self[key]
    out = out[0] if unwrap
    out = nil if out.empty?
    out
  end
end
