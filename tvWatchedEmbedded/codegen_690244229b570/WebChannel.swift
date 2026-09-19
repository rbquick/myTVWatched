//
//  WebChannel.swift
//  tvWatched
//
//  Created by Brian Quick on 2025-10-27.
//

import Foundation
struct WebChannel: Codable {
    let id: Int?
    let name: String?
    let country: Country?
    let officialSite: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case country = "country"
        case officialSite = "officialSite"
        
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        country = try values.decodeIfPresent(Country.self, forKey: .country)
        officialSite = try values.decodeIfPresent(String.self, forKey: .officialSite)
    }
}
