//
//  MyShow.swift
//  tvWatchedEmbedded
//
//  Created by Brian Quick on 2025-10-30.
//

import Foundation

struct MyShow: Codable, Equatable, Hashable, Identifiable {
    let id: Int
    let name: String
    let Kodi: Bool
    let Apollo: Bool
    let Watching: Bool
    let Rating: Int
    let comments: String?
    var episodes: [MyEpisode]
    
    enum CodingKeys: String, CodingKey {
        case id, name, Kodi, Apollo, Watching, Rating, comments, episodes
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.Kodi = try container.decode(Bool.self, forKey: .Kodi)
        self.Apollo = try container.decode(Bool.self, forKey: .Apollo)
        self.Watching = try container.decodeIfPresent(Bool.self, forKey: .Watching) ?? false
        self.Rating = try container.decodeIfPresent(Int.self, forKey: .Rating) ?? 0
        self.comments = try container.decodeIfPresent(String.self, forKey: .comments)
        self.episodes = try container.decode([MyEpisode].self, forKey: .episodes)
    }
    // Encoding method to conform to Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(Kodi, forKey: .Kodi)
        try container.encode(Apollo, forKey: .Apollo)
        try container.encode(Watching, forKey: .Watching)
        try container.encode(Rating, forKey: .Rating)
        try container.encodeIfPresent(comments, forKey: .comments)
        try container.encodeIfPresent(episodes, forKey: .episodes)
    }
    init(id: Int = 74443, name: String = "Newxxxxxx x xxxx x  x x", Kodi: Bool = false, Apollo: Bool = false, Watching: Bool = false, Rating: Int = 0, comments: String? = nil, episodes: [MyEpisode] = []) {
        self.id = id
        self.name = name
        self.Kodi = Kodi
        self.Apollo = Apollo
        self.Watching = Watching
        self.Rating = Rating
        self.comments = comments
        self.episodes = episodes
    }
    static func == (lhs: MyShow, rhs: MyShow) -> Bool {
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.episodes == rhs.episodes
        }
    }

