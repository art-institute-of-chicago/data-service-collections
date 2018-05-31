# coding: utf-8
class Delete < BaseModel

  def initialize
    super
    self.fq = 'deleted:true'
  end

  def _transform( data )

    # This allows data to use the get method
    data.extend LakeUnwrapper

    ret = {}
    ret[:lake_guid] = data.get(:id, false)
    ret[:indexed_at] = data.get(:timestamp, false).to_time(:utc).iso8601 rescue nil

    ret

  end

  def transform( data, ret )

    ret

  end

end
