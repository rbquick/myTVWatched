import Foundation
struct ShowBase : Codable, Identifiable {
	let id : Int?
	let url : String?
	let name : String?
	let type : String?
	let language : String?
	let genres : [String]?
	let status : String?
	let runtime : Int?
	let averageRuntime : Int?
	let premiered : String?
	let ended : String?
	let officialSite : String?
	let schedule : Schedule?
	let rating : Rating?
	let weight : Int?
	let network : Network?
	let webChannel : WebChannel?
	let dvdCountry : String?
	let externals : Externals?
	let image : MyImage?
	let summary : String?
	let updated : Int?
	let links : _links?
	let embedded : _embedded?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case url = "url"
		case name = "name"
		case type = "type"
		case language = "language"
		case genres = "genres"
		case status = "status"
		case runtime = "runtime"
		case averageRuntime = "averageRuntime"
		case premiered = "premiered"
		case ended = "ended"
		case officialSite = "officialSite"
		case schedule = "schedule"
		case rating = "rating"
		case weight = "weight"
		case network = "network"
		case webChannel = "webChannel"
		case dvdCountry = "dvdCountry"
		case externals = "externals"
		case image = "image"
		case summary = "summary"
		case updated = "updated"
		case links = "_links"
		case embedded = "_embedded"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		language = try values.decodeIfPresent(String.self, forKey: .language)
		genres = try values.decodeIfPresent([String].self, forKey: .genres)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		runtime = try values.decodeIfPresent(Int.self, forKey: .runtime)
		averageRuntime = try values.decodeIfPresent(Int.self, forKey: .averageRuntime)
		premiered = try values.decodeIfPresent(String.self, forKey: .premiered)
		ended = try values.decodeIfPresent(String.self, forKey: .ended)
		officialSite = try values.decodeIfPresent(String.self, forKey: .officialSite)
		schedule = try values.decodeIfPresent(Schedule.self, forKey: .schedule)
		rating = try values.decodeIfPresent(Rating.self, forKey: .rating)
		weight = try values.decodeIfPresent(Int.self, forKey: .weight)
		network = try values.decodeIfPresent(Network.self, forKey: .network)
		webChannel = try values.decodeIfPresent(WebChannel.self, forKey: .webChannel)
		dvdCountry = try values.decodeIfPresent(String.self, forKey: .dvdCountry)
		externals = try values.decodeIfPresent(Externals.self, forKey: .externals)
		image = try values.decodeIfPresent(MyImage.self, forKey: .image)
		summary = try values.decodeIfPresent(String.self, forKey: .summary)
		updated = try values.decodeIfPresent(Int.self, forKey: .updated)
		links = try values.decodeIfPresent(_links.self, forKey: .links)
		embedded = try values.decodeIfPresent(_embedded.self, forKey: .embedded)
	}
    
    init(id: Int? = nil, url: String? = nil, name: String? = nil, type: String? = nil, language: String? = nil, genres: [String]? = nil, status: String? = nil, runtime: Int? = nil, averageRuntime: Int? = nil, premiered: String? = nil, ended: String? = nil, officialSite: String? = nil, schedule: Schedule? = nil, rating: Rating? = nil, weight: Int? = nil, network: Network? = nil, webChannel: WebChannel? = nil, dvdCountry: String? = nil, externals: Externals? = nil, image: MyImage? = nil, summary: String? = nil, updated: Int? = nil, links: _links? = nil, embedded: _embedded? = nil) {
            self.id = id
            self.url = url
            self.name = name
            self.type = type
            self.language = language
            self.genres = genres
            self.status = status
            self.runtime = runtime
            self.averageRuntime = averageRuntime
            self.premiered = premiered
            self.ended = ended
            self.officialSite = officialSite
            self.schedule = schedule
            self.rating = rating
            self.weight = weight
            self.network = network
            self.webChannel = webChannel
            self.dvdCountry = dvdCountry
            self.externals = externals
            self.image = image
            self.summary = summary
            self.updated = updated
            self.links = links
            self.embedded = embedded
        }

}
