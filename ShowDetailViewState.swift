//
//  ShowDetailViewState.swift
//  myTVWatched
//
//  Created by Brian Quick on 2026-10-15.
//

import Combine

final class ShowDetailViewState: ObservableObject {
    @Published var show: ShowBase = ShowBase()
    @Published var apollo: Bool = false
    @Published var kodi: Bool = false
    @Published var watching: Bool = false
    @Published var rating: Int = 0
    @Published var comments: String = ""
    @Published var scrollepisodeID: Int = 0
    @Published var error: String?
    @Published var originalApollo: Bool = false
    @Published var originalKodi: Bool = false
    @Published var originalWatching: Bool = false
    @Published var originalRating: Int = 0
    @Published var originalComments: String = ""

}
