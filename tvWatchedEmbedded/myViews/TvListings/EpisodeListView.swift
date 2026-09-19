//
//  EpisodeListView.swift
//  tvWatchedEmbedded
//
//  Created by Brian Quick on 2025-10-29.
//
 
import SwiftUI

struct EpisodeListView: View {
    let episodes: [Episodes]
    var body: some View {
        List(episodes) { episode in
            Text(episode.name ?? "Unknown ")
        }
    }
}

#Preview {
    EpisodeListView(episodes: [])
}
