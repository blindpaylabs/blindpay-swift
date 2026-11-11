//
//  Common.swift
//  blindpay-swift
//
//  Created by Eric Viana on 03/11/25.
//

import Foundation

// MARK: - Country

/// Country code (ISO 3166-1 alpha-2)
public struct Country: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let af = Country(rawValue: "AF")
    public static let al = Country(rawValue: "AL")
    public static let dz = Country(rawValue: "DZ")
    public static let `as` = Country(rawValue: "AS")
    public static let ad = Country(rawValue: "AD")
    public static let ao = Country(rawValue: "AO")
    public static let ai = Country(rawValue: "AI")
    public static let aq = Country(rawValue: "AQ")
    public static let ag = Country(rawValue: "AG")
    public static let ar = Country(rawValue: "AR")
    public static let am = Country(rawValue: "AM")
    public static let aw = Country(rawValue: "AW")
    public static let au = Country(rawValue: "AU")
    public static let at = Country(rawValue: "AT")
    public static let az = Country(rawValue: "AZ")
    public static let bs = Country(rawValue: "BS")
    public static let bh = Country(rawValue: "BH")
    public static let bd = Country(rawValue: "BD")
    public static let bb = Country(rawValue: "BB")
    public static let by = Country(rawValue: "BY")
    public static let be = Country(rawValue: "BE")
    public static let bz = Country(rawValue: "BZ")
    public static let bj = Country(rawValue: "BJ")
    public static let bm = Country(rawValue: "BM")
    public static let bt = Country(rawValue: "BT")
    public static let bo = Country(rawValue: "BO")
    public static let bq = Country(rawValue: "BQ")
    public static let ba = Country(rawValue: "BA")
    public static let bw = Country(rawValue: "BW")
    public static let bv = Country(rawValue: "BV")
    public static let br = Country(rawValue: "BR")
    public static let io = Country(rawValue: "IO")
    public static let bn = Country(rawValue: "BN")
    public static let bg = Country(rawValue: "BG")
    public static let bf = Country(rawValue: "BF")
    public static let bi = Country(rawValue: "BI")
    public static let cv = Country(rawValue: "CV")
    public static let kh = Country(rawValue: "KH")
    public static let cm = Country(rawValue: "CM")
    public static let ca = Country(rawValue: "CA")
    public static let ky = Country(rawValue: "KY")
    public static let cf = Country(rawValue: "CF")
    public static let td = Country(rawValue: "TD")
    public static let cl = Country(rawValue: "CL")
    public static let cn = Country(rawValue: "CN")
    public static let cx = Country(rawValue: "CX")
    public static let cc = Country(rawValue: "CC")
    public static let co = Country(rawValue: "CO")
    public static let km = Country(rawValue: "KM")
    public static let cd = Country(rawValue: "CD")
    public static let cg = Country(rawValue: "CG")
    public static let ck = Country(rawValue: "CK")
    public static let cr = Country(rawValue: "CR")
    public static let hr = Country(rawValue: "HR")
    public static let cu = Country(rawValue: "CU")
    public static let cw = Country(rawValue: "CW")
    public static let cy = Country(rawValue: "CY")
    public static let cz = Country(rawValue: "CZ")
    public static let ci = Country(rawValue: "CI")
    public static let dk = Country(rawValue: "DK")
    public static let dj = Country(rawValue: "DJ")
    public static let dm = Country(rawValue: "DM")
    public static let `do` = Country(rawValue: "DO")
    public static let ec = Country(rawValue: "EC")
    public static let eg = Country(rawValue: "EG")
    public static let sv = Country(rawValue: "SV")
    public static let gq = Country(rawValue: "GQ")
    public static let er = Country(rawValue: "ER")
    public static let ee = Country(rawValue: "EE")
    public static let sz = Country(rawValue: "SZ")
    public static let et = Country(rawValue: "ET")
    public static let fk = Country(rawValue: "FK")
    public static let fo = Country(rawValue: "FO")
    public static let fj = Country(rawValue: "FJ")
    public static let fi = Country(rawValue: "FI")
    public static let fr = Country(rawValue: "FR")
    public static let gf = Country(rawValue: "GF")
    public static let pf = Country(rawValue: "PF")
    public static let tf = Country(rawValue: "TF")
    public static let ga = Country(rawValue: "GA")
    public static let gm = Country(rawValue: "GM")
    public static let ge = Country(rawValue: "GE")
    public static let de = Country(rawValue: "DE")
    public static let gh = Country(rawValue: "GH")
    public static let gi = Country(rawValue: "GI")
    public static let gr = Country(rawValue: "GR")
    public static let gl = Country(rawValue: "GL")
    public static let gd = Country(rawValue: "GD")
    public static let gp = Country(rawValue: "GP")
    public static let gu = Country(rawValue: "GU")
    public static let gt = Country(rawValue: "GT")
    public static let gg = Country(rawValue: "GG")
    public static let gn = Country(rawValue: "GN")
    public static let gw = Country(rawValue: "GW")
    public static let gy = Country(rawValue: "GY")
    public static let ht = Country(rawValue: "HT")
    public static let hm = Country(rawValue: "HM")
    public static let va = Country(rawValue: "VA")
    public static let hn = Country(rawValue: "HN")
    public static let hk = Country(rawValue: "HK")
    public static let hu = Country(rawValue: "HU")
    public static let `is` = Country(rawValue: "IS")
    public static let `in` = Country(rawValue: "IN")
    public static let id = Country(rawValue: "ID")
    public static let ir = Country(rawValue: "IR")
    public static let iq = Country(rawValue: "IQ")
    public static let ie = Country(rawValue: "IE")
    public static let im = Country(rawValue: "IM")
    public static let il = Country(rawValue: "IL")
    public static let it = Country(rawValue: "IT")
    public static let jm = Country(rawValue: "JM")
    public static let jp = Country(rawValue: "JP")
    public static let je = Country(rawValue: "JE")
    public static let jo = Country(rawValue: "JO")
    public static let kz = Country(rawValue: "KZ")
    public static let ke = Country(rawValue: "KE")
    public static let ki = Country(rawValue: "KI")
    public static let kp = Country(rawValue: "KP")
    public static let kr = Country(rawValue: "KR")
    public static let kw = Country(rawValue: "KW")
    public static let kg = Country(rawValue: "KG")
    public static let la = Country(rawValue: "LA")
    public static let lv = Country(rawValue: "LV")
    public static let lb = Country(rawValue: "LB")
    public static let ls = Country(rawValue: "LS")
    public static let lr = Country(rawValue: "LR")
    public static let ly = Country(rawValue: "LY")
    public static let li = Country(rawValue: "LI")
    public static let lt = Country(rawValue: "LT")
    public static let lu = Country(rawValue: "LU")
    public static let mo = Country(rawValue: "MO")
    public static let mg = Country(rawValue: "MG")
    public static let mw = Country(rawValue: "MW")
    public static let my = Country(rawValue: "MY")
    public static let mv = Country(rawValue: "MV")
    public static let ml = Country(rawValue: "ML")
    public static let mt = Country(rawValue: "MT")
    public static let mh = Country(rawValue: "MH")
    public static let mq = Country(rawValue: "MQ")
    public static let mr = Country(rawValue: "MR")
    public static let mu = Country(rawValue: "MU")
    public static let yt = Country(rawValue: "YT")
    public static let mx = Country(rawValue: "MX")
    public static let fm = Country(rawValue: "FM")
    public static let md = Country(rawValue: "MD")
    public static let mc = Country(rawValue: "MC")
    public static let mn = Country(rawValue: "MN")
    public static let me = Country(rawValue: "ME")
    public static let ms = Country(rawValue: "MS")
    public static let ma = Country(rawValue: "MA")
    public static let mz = Country(rawValue: "MZ")
    public static let mm = Country(rawValue: "MM")
    public static let na = Country(rawValue: "NA")
    public static let nr = Country(rawValue: "NR")
    public static let np = Country(rawValue: "NP")
    public static let nl = Country(rawValue: "NL")
    public static let nc = Country(rawValue: "NC")
    public static let nz = Country(rawValue: "NZ")
    public static let ni = Country(rawValue: "NI")
    public static let ne = Country(rawValue: "NE")
    public static let ng = Country(rawValue: "NG")
    public static let nu = Country(rawValue: "NU")
    public static let nf = Country(rawValue: "NF")
    public static let mp = Country(rawValue: "MP")
    public static let no = Country(rawValue: "NO")
    public static let om = Country(rawValue: "OM")
    public static let pk = Country(rawValue: "PK")
    public static let pw = Country(rawValue: "PW")
    public static let ps = Country(rawValue: "PS")
    public static let pa = Country(rawValue: "PA")
    public static let pg = Country(rawValue: "PG")
    public static let py = Country(rawValue: "PY")
    public static let pe = Country(rawValue: "PE")
    public static let ph = Country(rawValue: "PH")
    public static let pn = Country(rawValue: "PN")
    public static let pl = Country(rawValue: "PL")
    public static let pt = Country(rawValue: "PT")
    public static let pr = Country(rawValue: "PR")
    public static let qa = Country(rawValue: "QA")
    public static let mk = Country(rawValue: "MK")
    public static let ro = Country(rawValue: "RO")
    public static let ru = Country(rawValue: "RU")
    public static let rw = Country(rawValue: "RW")
    public static let re = Country(rawValue: "RE")
    public static let bl = Country(rawValue: "BL")
    public static let sh = Country(rawValue: "SH")
    public static let kn = Country(rawValue: "KN")
    public static let lc = Country(rawValue: "LC")
    public static let mf = Country(rawValue: "MF")
    public static let pm = Country(rawValue: "PM")
    public static let vc = Country(rawValue: "VC")
    public static let ws = Country(rawValue: "WS")
    public static let sm = Country(rawValue: "SM")
    public static let st = Country(rawValue: "ST")
    public static let sa = Country(rawValue: "SA")
    public static let sn = Country(rawValue: "SN")
    public static let rs = Country(rawValue: "RS")
    public static let sc = Country(rawValue: "SC")
    public static let sl = Country(rawValue: "SL")
    public static let sg = Country(rawValue: "SG")
    public static let sx = Country(rawValue: "SX")
    public static let sk = Country(rawValue: "SK")
    public static let si = Country(rawValue: "SI")
    public static let sb = Country(rawValue: "SB")
    public static let so = Country(rawValue: "SO")
    public static let za = Country(rawValue: "ZA")
    public static let gs = Country(rawValue: "GS")
    public static let ss = Country(rawValue: "SS")
    public static let es = Country(rawValue: "ES")
    public static let lk = Country(rawValue: "LK")
    public static let sd = Country(rawValue: "SD")
    public static let sr = Country(rawValue: "SR")
    public static let sj = Country(rawValue: "SJ")
    public static let se = Country(rawValue: "SE")
    public static let ch = Country(rawValue: "CH")
    public static let sy = Country(rawValue: "SY")
    public static let tw = Country(rawValue: "TW")
    public static let tj = Country(rawValue: "TJ")
    public static let tz = Country(rawValue: "TZ")
    public static let th = Country(rawValue: "TH")
    public static let tl = Country(rawValue: "TL")
    public static let tg = Country(rawValue: "TG")
    public static let tk = Country(rawValue: "TK")
    public static let to = Country(rawValue: "TO")
    public static let tt = Country(rawValue: "TT")
    public static let tn = Country(rawValue: "TN")
    public static let tr = Country(rawValue: "TR")
    public static let tm = Country(rawValue: "TM")
    public static let tc = Country(rawValue: "TC")
    public static let tv = Country(rawValue: "TV")
    public static let ug = Country(rawValue: "UG")
    public static let ua = Country(rawValue: "UA")
    public static let ae = Country(rawValue: "AE")
    public static let gb = Country(rawValue: "GB")
    public static let um = Country(rawValue: "UM")
    public static let us = Country(rawValue: "US")
    public static let uy = Country(rawValue: "UY")
    public static let uz = Country(rawValue: "UZ")
    public static let vu = Country(rawValue: "VU")
    public static let ve = Country(rawValue: "VE")
    public static let vn = Country(rawValue: "VN")
    public static let vg = Country(rawValue: "VG")
    public static let vi = Country(rawValue: "VI")
    public static let wf = Country(rawValue: "WF")
    public static let eh = Country(rawValue: "EH")
    public static let ye = Country(rawValue: "YE")
    public static let zm = Country(rawValue: "ZM")
    public static let zw = Country(rawValue: "ZW")
    public static let ax = Country(rawValue: "AX")
}

// MARK: - Pagination

/// One page of a list call.
///
/// List endpoints answer with a bare array when no `limit`, `startingAfter`
/// or `endingBefore` is sent, and with `{data, pagination}` when one is.
/// Both decode into `ListResult`: `pagination` is `nil` for the bare array.
/// An unpaginated call returns every row, so prefer the `listAutoPaging`
/// methods for large lists.
public struct ListResult<Element: Sendable>: Sendable {
    /// The items on this page.
    public let data: [Element]

    /// Cursor metadata; `nil` when the API returned a bare array.
    public let pagination: PaginationMetadata?

    public init(data: [Element], pagination: PaginationMetadata? = nil) {
        self.data = data
        self.pagination = pagination
    }

    enum CodingKeys: String, CodingKey {
        case data
        case pagination
    }
}

extension ListResult: Decodable where Element: Decodable {
    public init(from decoder: Decoder) throws {
        // An object is the envelope; anything else must be the bare array.
        // Element decoding errors propagate in both cases.
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            data = try container.decode([Element].self, forKey: .data)
            pagination = try container.decodeIfPresent(PaginationMetadata.self, forKey: .pagination)
        } else {
            data = try decoder.singleValueContainer().decode([Element].self)
            pagination = nil
        }
    }
}

extension ListResult: Encodable where Element: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encodeIfPresent(pagination, forKey: .pagination)
    }
}

extension ListResult: Equatable where Element: Equatable {}

/// Pagination metadata returned in API responses
public struct PaginationMetadata: Codable, Sendable, Equatable {
    /// Whether there are more pages available
    public let hasMore: Bool

    /// Next page cursor
    public let nextPage: String?

    /// Previous page cursor
    public let prevPage: String?

    public init(hasMore: Bool, nextPage: String? = nil, prevPage: String? = nil) {
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

