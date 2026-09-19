import Foundation
import SwiftUI
struct Episodes : Identifiable,  Codable {

    
	let id : Int?
	let url : String?
	let name : String?
	let season : Int?
	let number : Int?
	let type : String?
	let airdate : String?
	let airtime : String?
	let airstamp : String?
	let runtime : Int?
	let rating : Rating?
	let image : MyImage?
	let summary : String?
	let links : _links?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case url = "url"
		case name = "name"
		case season = "season"
		case number = "number"
		case type = "type"
		case airdate = "airdate"
		case airtime = "airtime"
		case airstamp = "airstamp"
		case runtime = "runtime"
		case rating = "rating"
		case image = "image"
		case summary = "summary"
		case links = "_links"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		season = try values.decodeIfPresent(Int.self, forKey: .season)
		number = try values.decodeIfPresent(Int.self, forKey: .number)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		airdate = try values.decodeIfPresent(String.self, forKey: .airdate)
		airtime = try values.decodeIfPresent(String.self, forKey: .airtime)
		airstamp = try values.decodeIfPresent(String.self, forKey: .airstamp)
		runtime = try values.decodeIfPresent(Int.self, forKey: .runtime)
		rating = try values.decodeIfPresent(Rating.self, forKey: .rating)
		image = try values.decodeIfPresent(MyImage.self, forKey: .image)
		summary = try values.decodeIfPresent(String.self, forKey: .summary)
		links = try values.decodeIfPresent(_links.self, forKey: .links)
	}
    internal init(id: Int? = nil, url: String? = nil, name: String? = nil, season: Int? = nil, number: Int? = nil, type: String? = nil, airdate: String? = nil, airtime: String? = nil, airstamp: String? = nil, runtime: Int? = nil, rating: Rating? = nil, image: MyImage? = nil, summary: String? = nil, links: _links? = nil) {
        self.id = id
        self.url = url
        self.name = name
        self.season = season
        self.number = number
        self.type = type
        self.airdate = airdate
        self.airtime = airtime
        self.airstamp = airstamp
        self.runtime = runtime
        self.rating = rating
        self.image = image
        self.summary = summary
        self.links = links
    }

}
struct Link: Codable {
    let href: String
}
//struct _links : Codable {
//
//    
//    let `self` : Link?
//    let show : Show?
//    
//    enum CodingKeys: String, CodingKey {
//        
//        case `self` = "self"
//        case show = "show"
//    }
//    internal init(`self`: Link? = nil, show: Show? = nil) {
//        self.`self` = `self`
//        self.show = show
//    }
//}

