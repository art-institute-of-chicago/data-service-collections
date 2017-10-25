class Exhibition < BaseModel

  def initialize
    super
    self.fq = 'hasModel:Exhibition'
    self.fq << ' AND -exhibitionType:"Non AIC Venues only" AND -exhibitionStatus:"Not assigned" AND -exhibitionStatus:"Pending"'
  end

  def transform( data, ret )

    ret[:exhibition_type] = data.get(:exhibitionType, false)

    ret[:department] = data.get(:department)
    ret[:department_id] = Integer( data.get(:department_citiUid) ) rescue nil

    ret[:description] = data.get(:description)

    ret

  end
end
