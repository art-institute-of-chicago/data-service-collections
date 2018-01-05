# Casts strings to integer
# Accepts arrays or single values

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
    out = value.to_i
  rescue
    nil
  end

end

