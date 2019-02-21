class Gallery < Place

  def initialize
    super

    self.fq = 'hasModel:Place'
    self.fq << ' AND (type:"http://definitions.artic.edu/ontology/1.0/WebMobilePublished"'

    # The above condition alone should work. But we're seeing some issues
    # with the LAKE data pipeline where place records are not getting the
    # WebMobilePublished RDF type in LPM Solr, and it's unclear when that
    # will get resolved. So in the mean time, following is a list of all
    # galleries that can have an artwork in it. This messy block makes
    # sure we're getting those.
    self.fq << ' 28764' # Gallery 59B (0)
    self.fq << ' 2147470998' # Gallery 137 (124)
    self.fq << ' 28763' # Gallery 59A (0)
    self.fq << ' 25290' # Gallery 234 (72)
    self.fq << ' 23997' # Gallery 182 (0)
    self.fq << ' 25085' # Gallery 126 (12)
    self.fq << ' 25287' # Gallery 232 (37)
    self.fq << ' 23992' # Gallery 394 (12)
    self.fq << ' 2707' # Gallery 57 (18)
    self.fq << ' 2706' # Gallery 58 (6)
    self.fq << ' 2147479701' # Gallery 245 (13)
    self.fq << ' 2147480089' # Gallery 108 (26)
    self.fq << ' 2147476040' # Gallery 165 (40)
    self.fq << ' 2147478064' # Gallery 262 (17)
    self.fq << ' 2147478065' # Gallery 263 (14)
    self.fq << ' 2147471010' # Gallery 171 (34)
    self.fq << ' 2147475001' # Gallery 163 (7)
    self.fq << ' 2147476055' # Gallery 167 (42)
    self.fq << ' 2147476050' # Gallery 175 (17)
    self.fq << ' 2147476836' # Gallery 227 (80)
    self.fq << ' 2147475518' # Gallery 264 (16)
    self.fq << ' 2147476052' # Gallery 169 (33)
    self.fq << ' 2147476048' # Gallery 178 (14)
    self.fq << ' 2147476049' # Gallery 176 (23)
    self.fq << ' 2147476037' # Gallery 179 (19)
    self.fq << ' 2147478066' # Gallery 265 (27)
    self.fq << ' 23989' # Gallery 391A (0)
    self.fq << ' 23990' # Gallery 392A (0)
    self.fq << ' 23991' # Gallery 393A (0)
    self.fq << ' 23993' # Gallery 395A (0)
    self.fq << ' 23994' # Gallery 396A (0)
    self.fq << ' 24564' # Gallery 391B (0)
    self.fq << ' 24565' # Gallery 392B (0)
    self.fq << ' 24566' # Gallery 393B (0)
    self.fq << ' 24568' # Gallery 395B (0)
    self.fq << ' 24569' # Gallery 395C (0)
    self.fq << ' 24570' # Gallery 396B (0)
    self.fq << ' 23996' # Gallery 398A (0)
    self.fq << ' 2147478129' # Gallery 106 (25)
    self.fq << ' 2147480090' # Gallery 107 (52)
    self.fq << ' 25083' # Gallery 124B (14)
    self.fq << ' 28497' # Gallery 238A (0)
    self.fq << ' 2147483611' # Gallery 220 (36)
    self.fq << ' 2147483643' # Gallery 201 (22)
    self.fq << ' 28765' # Gallery 59C (0)
    self.fq << ' 24571' # Gallery 398B (0)
    self.fq << ' 2147476051' # Gallery 174 (20)
    self.fq << ' 25456' # Gallery 288 (Corridor North) (0)
    self.fq << ' 2147476019' # Gallery 177 (23)
    self.fq << ' 2147476004' # Gallery 164 (7)
    self.fq << ' 2147477236' # Gallery 161 (39)
    self.fq << ' 28496' # Gallery 238 (158)
    self.fq << ' 26774' # Gallery 152 (12)
    self.fq << ' 2147483623' # Gallery 213 (39)
    self.fq << ' 25293' # Gallery 231 (34)
    self.fq << ' 2147475157' # Gallery 162 (32)
    self.fq << ' 26773' # Gallery 151 (134)
    self.fq << ' 26509' # Gallery 199 (Touch Gallery) (4)
    self.fq << ' 24305' # Gallery 295C (0)
    self.fq << ' 25473' # Gallery 297 (14)
    self.fq << ' 24300' # Gallery 297A (0)
    self.fq << ' 28500' # Gallery 238C (0)
    self.fq << ' 24304' # Gallery 295B (0)
    self.fq << ' 2147483612' # Gallery 219a (0)
    self.fq << ' 25082' # Gallery 124A (30)
    self.fq << ' 2147479700' # Gallery 246 (45)
    self.fq << ' 2147483606' # Gallery 223 (24)
    self.fq << ' 2147478117' # Gallery 134 (178)
    self.fq << ' 2147483613' # Gallery 219 (20)
    self.fq << ' 28498' # Gallery 239 (328)
    self.fq << ' 26746' # Gallery 237 (36)
    self.fq << ' 2147475440' # Gallery 136 (305)
    self.fq << ' 26129' # Gallery 50 (78)
    self.fq << ' 23970' # Gallery 285 (110)
    self.fq << ' 2147483635' # Gallery 205 (47)
    self.fq << ' 346' # Stock Exchange Trading Room (1)
    self.fq << ' 23995' # Gallery 397 (116)
    self.fq << ' 26776' # Gallery 153 (34)
    self.fq << ' 2147477257' # Gallery 11 (70)
    self.fq << ' 25288' # Gallery 233 (26)
    self.fq << ' 24651' # Gallery 142 (50)
    self.fq << ' 2147477218' # Gallery 200 (79)
    self.fq << ' 24650' # Gallery 141 (27)
    self.fq << ' 2147478132' # Gallery 103 (7)
    self.fq << ' 2147478130' # Gallery 105 (42)
    self.fq << ' 2147478672' # Gallery 240 (13)
    self.fq << ' 2147479705' # Gallery 241 (15)
    self.fq << ' 24000' # Gallery 185 (Griffin Court) (1)
    self.fq << ' 24366' # Gallery 289A (0)
    self.fq << ' 24306' # Gallery 293B (0)
    self.fq << ' 2147483607' # Gallery 222 (21)
    self.fq << ' 28838' # Gallery 285F (0)
    self.fq << ' 23975' # Gallery 294 (10)
    self.fq << ' 23967' # Gallery 283 (1)
    self.fq << ' 28834' # Gallery 285B (0)
    self.fq << ' 2698' # Gallery 200C Northwest Alcove (9)
    self.fq << ' 28840' # Gallery 285H (0)
    self.fq << ' 28841' # Gallery 285I (0)
    self.fq << ' 24572' # Gallery 398C (0)
    self.fq << ' 28836' # Gallery 285D (0)
    self.fq << ' 28837' # Gallery 285E (0)
    self.fq << ' 28835' # Gallery 285C (0)
    self.fq << ' 2147472240' # Ryerson Library Reading Room (29)
    self.fq << ' 2147483626' # Gallery 211 (18)
    self.fq << ' 2147483630' # Gallery 208 (34)
    self.fq << ' 2147483633' # Gallery 206 (23)
    self.fq << ' 28839' # Gallery 285G (0)
    self.fq << ' 2147483636' # Gallery 204a (0)
    self.fq << ' 2147483637' # Gallery 204 (22)
    self.fq << ' 2147478068' # Gallery 272 (0)
    self.fq << ' 21434' # Gallery 273 (0)
    self.fq << ' 27496' # Gallery 50B (0)
    self.fq << ' 2147478134' # Gallery 101A (2)
    self.fq << ' 2147483622' # Gallery 213a (0)
    self.fq << ' 2147483604' # Gallery 224 (8)
    self.fq << ' 2147483617' # Gallery 216a (0)
    self.fq << ' 2147483618' # Gallery 216 (75)
    self.fq << ' 2147479702' # Gallery 244 (12)
    self.fq << ' 2147479699' # Gallery 247 (8)
    self.fq << ' 2147478118' # Gallery 132 (188)
    self.fq << ' 2147478119' # Gallery 131b (0)
    self.fq << ' 25480' # Gallery 131 (165)
    self.fq << ' 2147483638' # Gallery 203 (1)
    self.fq << ' 25084' # Gallery 125 (25)
    self.fq << ' 2147478135' # Gallery 101 (10)
    self.fq << ' 26772' # Gallery 150 (2)
    self.fq << ' 2147480173' # Gallery 109 (9)
    self.fq << ' 2147478120' # Gallery 131a (0)
    self.fq << ' 2147479704' # Gallery 242 (8)
    self.fq << ' 2147483603' # Gallery 225 (78)
    self.fq << ' 2147476007' # Gallery 173 (25)
    self.fq << ' 2147476006' # Gallery 172 (37)
    self.fq << ' 24317' # Gallery 189 (Corridor) (46)
    self.fq << ' 2147479698' # Gallery 248 (11)
    self.fq << ' 2147483614' # Gallery 218 (19)
    self.fq << ' 2147479697' # Gallery 249 (2)
    self.fq << ' 2147476053' # Gallery 168 (26)
    self.fq << ' 2147476039' # Gallery 166 (42)
    self.fq << ' 2147476014' # Gallery 170 (7)
    self.fq << ' 2147483609' # Gallery 221 (23)
    self.fq << ' 2147473659' # Michigan Avenue entrance/steps (2)
    self.fq << ' 25087' # Gallery 127B (8)
    self.fq << ' 2147483624' # Gallery 212a (0)
    self.fq << ' 2147483610' # Gallery 220a (0)
    self.fq << ' 24573' # Gallery 399 (1)
    self.fq << ' 2147477076' # North Stanley McCormick Memorial Garden (4)
    self.fq << ' 26132' # Gallery 144 (5)
    self.fq << ' 25237' # Pritzker Garden (2)
    self.fq << ' 2147478061' # Gallery 261 (6)
    self.fq << ' 28501' # Gallery 238D (0)
    self.fq << ' 2147483640' # Gallery 202 (26)
    self.fq << ' 25086' # Gallery 127A (7)
    self.fq << ' 24301' # Gallery 297C (0)
    self.fq << ' 2147480055' # Gallery 236 (54)
    self.fq << ' 2147483632' # Gallery 207 (25)
    self.fq << ' 26777' # Gallery 154 (4)
    self.fq << ' 23972' # Gallery 297B (0)
    self.fq << ' 2147483625' # Gallery 212 (14)
    self.fq << ' 28502' # Gallery 239A (0)
    self.fq << ' 28503' # Gallery 239B (0)
    self.fq << ' 2147477833' # Gallery 133 (44)
    self.fq << ' 2147478121' # Gallery 130 (2)
    self.fq << ' 2147478133' # Gallery 102 (12)
    self.fq << ' 2147478131' # Gallery 104 (14)
    self.fq << ' 2147479703' # Gallery 243 (19)
    self.fq << ' 2147483601' # Gallery 226 (19)
    self.fq << ' 2147483621' # Gallery 214 (35)
    self.fq << ' 2147483619' # Gallery 215 (28)
    self.fq << ' 2147483616' # Gallery 217 (21)
    self.fq << ' 2147483628' # Gallery 209 (14)
    self.fq << ' 23978' # Gallery 291A (0)
    self.fq << ' 28504' # Gallery 239C (0)
    self.fq << ' 25289' # Gallery 233A (0)
    self.fq << ' 25736' # case 02 (0)
    self.fq << ' 25740' # case 06 (0)
    self.fq << ' 25747' # case 13 (0)
    self.fq << ' 28499' # Gallery 238B (0)
    self.fq << ' 27513' # Small Case 4 (0)
    self.fq << ' 25741' # case 07 (0)
    self.fq << ' 25745' # case 11 (0)
    self.fq << ' 25735' # case 01 (0)
    self.fq << ' 25737' # case 03 (0)
    self.fq << ' 25738' # case 04 (0)
    self.fq << ' 25739' # case 05 (0)
    self.fq << ' 25742' # case 08 (0)
    self.fq << ' 25743' # case 09 (0)
    self.fq << ' 25744' # case 10 (0)
    self.fq << ' 25746' # case 12 (0)
    self.fq << ' 28505' # Gallery 239D (0)
    self.fq << ' 23974' # Gallery 295A (0)
    self.fq << ' 23973' # Gallery 296A (0)
    self.fq << ' 23976' # Gallery 293A (0)
    self.fq << ' 24302' # Gallery 296B (0)
    self.fq << ' 24303' # Gallery 296C (0)
    self.fq << ' 23977' # Gallery 292B (0)
    self.fq << ' 24308' # Gallery 292A (0)
    self.fq << ' 24312' # Gallery 289C (0)
    self.fq << ' 24310' # Gallery 291B (0)
    self.fq << ' 2147483600' # Gallery 226a (0)
    self.fq << ' 2147483602' # Gallery 225a (0)
    self.fq << ' 2147483615' # Gallery 217a (0)
    self.fq << ' 2147483627' # Gallery 209a (0)
    self.fq << ' 2147483629' # Gallery 208a (0)
    self.fq << ' 2147483631' # Gallery 207a (0)
    self.fq << ' 2147483605' # Gallery 223a (0)
    self.fq << ' 2147483608' # Gallery 221a (0)
    self.fq << ' 2147483634' # Gallery 205a (0)
    self.fq << ' 2147474874' # Gallery 135 (1)
    self.fq << ' 24649' # Gallery 140 (26)
    self.fq << ' 27710' # case 16 (0)
    self.fq << ' 2697' # Gallery 200b - Barbara Hillman Frankel and David Aaron Frankel Gallery (0)
    self.fq << ' 2147483599' # Fullerton Hall Lobby (1)
    self.fq << ' 2147483639' # Gallery 202a (0)
    self.fq << ' 2' # East Garden at Columbus Drive (1)
    self.fq << ' 27497' # Gallery 50A (0)
    self.fq << ' 27502' # Large Case 4 (0)
    self.fq << ' 27504' # Large Case 6 (0)
    self.fq << ' 27505' # Large Case 7 (0)
    self.fq << ' 27508' # Introductory Case (0)
    self.fq << ' 27518' # Architectural Elements1 (0)
    self.fq << ' 27500' # Large Case 2 (0)
    self.fq << ' 27507' # Large Case 8 (0)
    self.fq << ' 27499' # Large Case 1 (0)
    self.fq << ' 27501' # Large Case 3 (0)
    self.fq << ' 27707' # case 15 (0)
    self.fq << ' 25748' # case 14 (0)
    self.fq << ' 2147476865' # The Garden Cafe,  McKinlock  Court-outdoors (1)
    self.fq << ' 28833' # Gallery 285A (0)
    self.fq << ' 2147472011' # Gallery 200a - Middle of Grand Staircase (0)
    self.fq << ' 24575' # Gallery 288 (Corridor South) (1)
    self.fq << ')'
  end

  # TODO: Abstract boolean into lake_unwrapper.rb (?)
  # isClosed contains some irregularities that prevent it from abstraction
  # https://lakesolridxweb.artic.edu/solr/lpm/select?wt=json&facet.field=isClosed&facet.limit=-1&rows=0
  def isClosed( data )

    # default to expectations...
    return true if data == "<Closed>"

    return false if data == "<NOT Closed>"
    return false

    # historic responses, for reference:
    return false if data == nil
    return true if data == "True"
    return false if data == "False"
    return false if data == "<NOT Closed>"

  end

  def transform( data, ret )

    # Get type from Place
    ret = super(data, ret)

    # Get latitude and longitude via inherited method
    ret = self.getLatLong(data, ret)

    ret[:closed] = isClosed( data.get(:isClosed) )

    # Some galleryNumbers are NOT numbers, e.g. 297A
    ret[:number] = data.get(:galleryNumber)

    # Some galleryFloors are NOT numbers, e.g. LL
    # https://lakesolridxweb.artic.edu/solr/lpm_prod/select?wt=json&facet.field=galleryFloor&facet.limit=-1&rows=0
    ret[:floor] = data.get(:galleryFloor)

    # I don't want to pass names. Waiting until we get GUIDs.
    # ret[:category] = data.get(:publishCategory)

    ret

  end
end
