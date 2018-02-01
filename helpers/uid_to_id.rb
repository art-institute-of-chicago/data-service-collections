# Casts UIDs (e.g., WO-11111) to integer
# Accepts arrays or single values

def uid2id(value)

  if value.kind_of?(Array)
    return value.map { |n| _uid2id(n) }
  end

  return _uid2id(value)

end

# Helper function, don't use directly
def _uid2id(value)

  if value == nil
    return nil
  end

  begin
    Integer ( /[A-Z]+-(-?[0-9]+)/.match(value)[1] )
  rescue
    nil
  end

end

