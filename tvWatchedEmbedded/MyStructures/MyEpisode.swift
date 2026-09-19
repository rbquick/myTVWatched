//
//  MyEpisodes.swift
//  tvWatchedEmbedded
//
//  Created by Brian Quick on 2025-10-30.
//

import Foundation

struct MyEpisode: Codable, Equatable, Hashable, Identifiable {
    let id: Int
    var season : Int?
    var number : Int?
    var dateWatched: String
    
    enum CodingKeys: String, CodingKey {
        case id, season, number, dateWatched
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.season = try container.decodeIfPresent(Int.self, forKey: .season)
        self.number = try container.decodeIfPresent(Int.self, forKey: .number)
        self.dateWatched = try container.decode(String.self, forKey: .dateWatched)
    }
    // Encoding method to satisfy Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(season, forKey: .season)
        try container.encodeIfPresent(number, forKey: .number)
        try container.encodeIfPresent(dateWatched, forKey: .dateWatched)
    }
    init (id: Int = 0, season: Int = 0, number: Int = 0, dateWatched: String = "") {
        self.id = id
        self.season = season
        self.number = number
        self.dateWatched = dateWatched
    }
    static func == (lhs: MyEpisode, rhs: MyEpisode) -> Bool {
            lhs.id == rhs.id &&
            lhs.dateWatched == rhs.dateWatched
    }
}


