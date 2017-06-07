def CitiId(value)

  begin
    Integer( /[0-9]+/.match(value)[0] )
  rescue
    nil
  end

end