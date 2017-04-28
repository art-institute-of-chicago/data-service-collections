# Navigate LAKE Solr data
module LakeUnwrapper
  def get(key, unwrap = true, int = false)
    key = key.to_s
    return nil unless key?(key)
    out = self[key]
    out = out[0] if unwrap
    out = out.to_i if int
    out
  end
end
