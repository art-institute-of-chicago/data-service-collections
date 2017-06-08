# Converts a LAKE URI to LAKE GUID
# Accepts arrays or single values

def Uri2Guid(value)

  if value.kind_of?(Array)
    return value.map { |n| _Uri2Guid(n) }
  end

  return _Uri2Guid(value)

end

# Helper function, don't use directly
def _Uri2Guid(value)

  begin
    out = value.split('/')
    out[-1]
  rescue
    nil
  end

end