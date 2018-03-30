# Issue a subquery for multiple ids
# Accepts arrays or single values

# Used for unwrapping pivots

def pivot(model, value)

  if value == nil
    return nil
  end

  # Get the `rows` and ensure value is an array
  if value.kind_of?(Array)
    per_page = value.length
  else
    value = value.to_a
    per_page = 1
  end

  # Implode into comma-separated string
  value = value.join(",")

  # Emulate new Solr request

  inst = model.new

  inst.paginate( '', 1, per_page )

  result = inst.find_all( value )

  # abort result.inspect

  return result[:data]

end
