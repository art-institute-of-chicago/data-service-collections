# Changes namespaced LAKE UIDs to original CITI ones
# Accepts arrays or single values

def Lake2Citi(value)

  if value.kind_of?(Array)
    return value.map { |n| _Lake2Citi(n) }
  end

  return _Lake2Citi(value)

end


# Helper function, don't use directly
def _Lake2Citi(value)

  if value == nil
    return nil
  end

  begin
    Integer ( /-?([0-9]+)/.match(value)[1] )
  rescue
    nil
  end

end
