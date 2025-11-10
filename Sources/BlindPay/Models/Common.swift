//
//  Common.swift
//  blindpay-swift
//
//  Created by Eric Viana on 03/11/25.
//

import Foundation

// MARK: - Country

/// Country code (ISO 3166-1 alpha-2)
public enum Country: String, Codable, Sendable {
    case af = "AF"
    case al = "AL"
    case dz = "DZ"
    case `as` = "AS"
    case ad = "AD"
    case ao = "AO"
    case ai = "AI"
    case aq = "AQ"
    case ag = "AG"
    case ar = "AR"
    case am = "AM"
    case aw = "AW"
    case au = "AU"
    case at = "AT"
    case az = "AZ"
    case bs = "BS"
    case bh = "BH"
    case bd = "BD"
    case bb = "BB"
    case by = "BY"
    case be = "BE"
    case bz = "BZ"
    case bj = "BJ"
    case bm = "BM"
    case bt = "BT"
    case bo = "BO"
    case bq = "BQ"
    case ba = "BA"
    case bw = "BW"
    case bv = "BV"
    case br = "BR"
    case io = "IO"
    case bn = "BN"
    case bg = "BG"
    case bf = "BF"
    case bi = "BI"
    case cv = "CV"
    case kh = "KH"
    case cm = "CM"
    case ca = "CA"
    case ky = "KY"
    case cf = "CF"
    case td = "TD"
    case cl = "CL"
    case cn = "CN"
    case cx = "CX"
    case cc = "CC"
    case co = "CO"
    case km = "KM"
    case cd = "CD"
    case cg = "CG"
    case ck = "CK"
    case cr = "CR"
    case hr = "HR"
    case cu = "CU"
    case cw = "CW"
    case cy = "CY"
    case cz = "CZ"
    case ci = "CI"
    case dk = "DK"
    case dj = "DJ"
    case dm = "DM"
    case `do` = "DO"
    case ec = "EC"
    case eg = "EG"
    case sv = "SV"
    case gq = "GQ"
    case er = "ER"
    case ee = "EE"
    case sz = "SZ"
    case et = "ET"
    case fk = "FK"
    case fo = "FO"
    case fj = "FJ"
    case fi = "FI"
    case fr = "FR"
    case gf = "GF"
    case pf = "PF"
    case tf = "TF"
    case ga = "GA"
    case gm = "GM"
    case ge = "GE"
    case de = "DE"
    case gh = "GH"
    case gi = "GI"
    case gr = "GR"
    case gl = "GL"
    case gd = "GD"
    case gp = "GP"
    case gu = "GU"
    case gt = "GT"
    case gg = "GG"
    case gn = "GN"
    case gw = "GW"
    case gy = "GY"
    case ht = "HT"
    case hm = "HM"
    case va = "VA"
    case hn = "HN"
    case hk = "HK"
    case hu = "HU"
    case `is` = "IS"
    case `in` = "IN"
    case id = "ID"
    case ir = "IR"
    case iq = "IQ"
    case ie = "IE"
    case im = "IM"
    case il = "IL"
    case it = "IT"
    case jm = "JM"
    case jp = "JP"
    case je = "JE"
    case jo = "JO"
    case kz = "KZ"
    case ke = "KE"
    case ki = "KI"
    case kp = "KP"
    case kr = "KR"
    case kw = "KW"
    case kg = "KG"
    case la = "LA"
    case lv = "LV"
    case lb = "LB"
    case ls = "LS"
    case lr = "LR"
    case ly = "LY"
    case li = "LI"
    case lt = "LT"
    case lu = "LU"
    case mo = "MO"
    case mg = "MG"
    case mw = "MW"
    case my = "MY"
    case mv = "MV"
    case ml = "ML"
    case mt = "MT"
    case mh = "MH"
    case mq = "MQ"
    case mr = "MR"
    case mu = "MU"
    case yt = "YT"
    case mx = "MX"
    case fm = "FM"
    case md = "MD"
    case mc = "MC"
    case mn = "MN"
    case me = "ME"
    case ms = "MS"
    case ma = "MA"
    case mz = "MZ"
    case mm = "MM"
    case na = "NA"
    case nr = "NR"
    case np = "NP"
    case nl = "NL"
    case nc = "NC"
    case nz = "NZ"
    case ni = "NI"
    case ne = "NE"
    case ng = "NG"
    case nu = "NU"
    case nf = "NF"
    case mp = "MP"
    case no = "NO"
    case om = "OM"
    case pk = "PK"
    case pw = "PW"
    case ps = "PS"
    case pa = "PA"
    case pg = "PG"
    case py = "PY"
    case pe = "PE"
    case ph = "PH"
    case pn = "PN"
    case pl = "PL"
    case pt = "PT"
    case pr = "PR"
    case qa = "QA"
    case mk = "MK"
    case ro = "RO"
    case ru = "RU"
    case rw = "RW"
    case re = "RE"
    case bl = "BL"
    case sh = "SH"
    case kn = "KN"
    case lc = "LC"
    case mf = "MF"
    case pm = "PM"
    case vc = "VC"
    case ws = "WS"
    case sm = "SM"
    case st = "ST"
    case sa = "SA"
    case sn = "SN"
    case rs = "RS"
    case sc = "SC"
    case sl = "SL"
    case sg = "SG"
    case sx = "SX"
    case sk = "SK"
    case si = "SI"
    case sb = "SB"
    case so = "SO"
    case za = "ZA"
    case gs = "GS"
    case ss = "SS"
    case es = "ES"
    case lk = "LK"
    case sd = "SD"
    case sr = "SR"
    case sj = "SJ"
    case se = "SE"
    case ch = "CH"
    case sy = "SY"
    case tw = "TW"
    case tj = "TJ"
    case tz = "TZ"
    case th = "TH"
    case tl = "TL"
    case tg = "TG"
    case tk = "TK"
    case to = "TO"
    case tt = "TT"
    case tn = "TN"
    case tr = "TR"
    case tm = "TM"
    case tc = "TC"
    case tv = "TV"
    case ug = "UG"
    case ua = "UA"
    case ae = "AE"
    case gb = "GB"
    case um = "UM"
    case us = "US"
    case uy = "UY"
    case uz = "UZ"
    case vu = "VU"
    case ve = "VE"
    case vn = "VN"
    case vg = "VG"
    case vi = "VI"
    case wf = "WF"
    case eh = "EH"
    case ye = "YE"
    case zm = "ZM"
    case zw = "ZW"
    case ax = "AX"
}

// MARK: - Pagination

/// Pagination parameters for API requests
public struct PaginationParams: Codable, Sendable {
    /// Number of items per page
    public let limit: String?
    
    /// Offset for pagination
    public let offset: String?
    
    /// Cursor for pagination (starting after this ID)
    public let startingAfter: String?
    
    /// Cursor for pagination (ending before this ID)
    public let endingBefore: String?
    
    public init(
        limit: String? = nil,
        offset: String? = nil,
        startingAfter: String? = nil,
        endingBefore: String? = nil
    ) {
        self.limit = limit
        self.offset = offset
        self.startingAfter = startingAfter
        self.endingBefore = endingBefore
    }
    
    enum CodingKeys: String, CodingKey {
        case limit
        case offset
        case startingAfter = "starting_after"
        case endingBefore = "ending_before"
    }
}

/// Pagination metadata returned in API responses
public struct PaginationMetadata: Codable, Sendable, Equatable {
    /// Whether there are more pages available
    public let hasMore: Bool
    
    /// Next page number
    public let nextPage: Int
    
    /// Previous page number
    public let prevPage: Int
    
    public init(hasMore: Bool, nextPage: Int, prevPage: Int) {
        self.hasMore = hasMore
        self.nextPage = nextPage
        self.prevPage = prevPage
    }
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case nextPage = "next_page"
        case prevPage = "prev_page"
    }
}

