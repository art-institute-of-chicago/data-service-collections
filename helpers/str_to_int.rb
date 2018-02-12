# Casts strings to integer
# Accepts arrays or single values

# Can change namespaced LAKE UIDs to original CITI ones

def str2int(value)

  if value.kind_of?(Array)
    return value.map { |n| _str2int(n) }
  end

  return _str2int(value)

end

# Helper function, don't use directly
def _str2int(value)

  if value == nil
    return nil
  end

  begin
    Integer ( /-?([0-9]+)/.match(value)[1] )
  rescue
    nil
  end

end

