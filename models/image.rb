# AFAICT, Images do not contain Interpretive Resource fields
# If so, it would be pointless to extend ResourceModel... but
# (1) the data aggregator core expects it, and (2) this might change again
class Image < ResourceModel

  def initialize
    super
    # TODO: Several internal images snuck into the LPM, but don't appear in the LPM IIIF
    self.fq = 'type:*StillImage -type:*InternalUseOnly'
  end

  def transform( data, ret )

    ret = super( data, ret )

    pref_rep_of_uids = data.get(:isPreferredRepresentationOfUid_uid, false) || []
    rep_of_uids = data.get(:isRepresentationOfUid_uid, false) || []

    alt_rep_of_uids = rep_of_uids - pref_rep_of_uids

    pref_reps = getRels(pref_rep_of_uids, true, false)
    alt_reps = getRels(alt_rep_of_uids, false, false)

    ret[:rep_of_artworks] = pref_reps[:artworks] + alt_reps[:artworks]
    ret[:rep_of_exhibitions] = pref_reps[:exhibitions] + alt_reps[:exhibitions]

    # Uncomment for debug:
    # ret[:is_pref_rep_of_ids] = pref_rep_of_uids
    # ret[:is_rep_of_ids] = rep_of_uids

    # TODO: Derive type of image by this field?
    # https://lakesolridxweb.artic.edu/solr/lpm/select?wt=json&rows=0&facet.field=documentType_uri

    ret

  end
end

