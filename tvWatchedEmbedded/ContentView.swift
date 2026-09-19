//
//  ContentView.swift
//  tvWatchedEmbedded
//
//  Created by Brian Quick on 2025-10-29.
//

import SwiftUI
import Combine

final class ContentViewState: ObservableObject {
    @Published var show : ShowBase = ShowBase()
    @Published var error: String?
}
struct ContentView: View {
    @StateObject private var state: ContentViewState
    var body: some View {
        VStack {
            
            Text(state.show.name ?? "unKnown")
            Text(state.show.embedded?.episodes?[0].name ?? "Unknown episode")
        }
        .padding()
        .onAppear {
            Task {
                await loadShows(showName:  "A Man on the Inside")
            }
        }
    }
    func loadShows(showName: String) async {
//        guard let url = URL(string: "https://api.tvmaze.com/singlesearch/shows?q=\(showName)&embed=episodes") else {
            guard let url = URL(string: "https://api.tvmaze.com/shows/74443?embed=episodes") else {
                state.error = "Invalid URL"
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let results = try JSONDecoder().decode(ShowBase.self, from: data)
            state.show = results
        } catch {
            state.error = error.localizedDescription
        }
    }
}



