//
//  ShowDetailView.swift
//  tvWatchedEmbedded
//
//  Created by Brian Quick on 2025-10-29.
//

import SwiftUI
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
struct ShowDetailView: View {
    @EnvironmentObject var myshowsmodel: MyShowsModel
    @StateObject private var state = ShowDetailViewState()
    var myshow: MyShow

    
    private var hasChanges: Bool {
        state.apollo != state.originalApollo ||
        state.kodi != state.originalKodi ||
        state.watching != state.originalWatching ||
        state.rating != state.originalRating ||
        state.comments != state.originalComments
    }
    
//    init(myshow: MyShow) {
//        self.myshow = myshow
//         // Initialize the state from myshow property
//         _apollo = State(initialValue: myshow.Apollo)
//        _kodi = State(initialValue: myshow.Kodi)
//        if myshow.episodes.count > 0 {
//            _scrollepisodeID = State(initialValue: myshow.episodes[0].id)
//        }
//     }
    
    var sortedEpisodes: [Episodes] {
        (state.show.embedded?.episodes ?? []).sorted {
            if let season0 = $0.season, let season1 = $1.season, season0 != season1 {
                return season0 > season1 // descending season
            }
            if let number0 = $0.number, let number1 = $1.number {
                return number0 > number1 // descending episode number
            }
            return false
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                
                if let image = state.show.image?.medium {
                    AsyncImage(url: URL(string: image)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 200)
                    } placeholder: {
                        ProgressView()
                    }
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text(myshow.name)
                            .font(.largeTitle)
                            .bold()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    HStack(alignment: .center, spacing: 16) {
                        HStack(spacing: 4) {
                            Toggle("", isOn: $state.watching)
                                .labelsHidden()
                                .toggleStyle(.switch)
                                .frame(minWidth: 0, alignment: .leading)
                            Text(state.watching ? "watching" : "NOT watching")
                        }
                        HStack(spacing: 4) {
                            Toggle("", isOn: $state.apollo)
                                .labelStyle(.automatic)
                                .frame(minWidth: 0, alignment: .leading)
                            Text(state.apollo ? "On Appollo" : "NOT on Appollo")
                        }
                        HStack(spacing: 4) {
                            Toggle("", isOn: $state.kodi)
                                .labelStyle(.automatic)
                                .frame(minWidth: 0, alignment: .leading)
                            Text(state.kodi ? "On Kodi" : "NOT on Kodi")
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    TextEditor(text: $state.comments)
                        .frame(minHeight: 48, maxHeight: 80) // Adjust minHeight as desired for two lines
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.vertical, 4)
                    // Placeholder isn't natively supported, but label is clear from context
                    HStack {
                        Spacer()
                        StarRatingView(rating: $state.rating, onColor: Color.red)
                        Spacer()
                        Button("Save") {
                            print("Save..............")
                            myshowsmodel.updatedevice(myshowid: myshow.id, apollo: state.apollo, kodi: state.kodi, watching: state.watching, Rating: state.rating, comments: state.comments)
                            myshowsmodel.saveMy()
                            setOriginals()
                        }
                        .buttonStyle(myButtonStyle(backgroundColor: hasChanges ? .red : .clear))
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .frame(height: 200)
            .padding(.horizontal)
            .background(.yellow.opacity(1.0))

            if let episodes = state.show.embedded?.episodes, !episodes.isEmpty {
                ScrollViewReader { proxy in
                    List(sortedEpisodes, id: \.id) { episode in
                        HStack {
                            Spacer()
                            EpisodeDetailView(myshowid: myshow.id, episode: episode)
                            Spacer()
                        }
                        .padding(.vertical, 4)
                        .id(episode.id)
                    }
                    .onAppear {
                        proxy.scrollTo(state.scrollepisodeID, anchor: .center)
                    }
                    .onChange(of: state.show.id) { _, _ in
                        if myshow.episodes.isEmpty { return }
                        state.scrollepisodeID = myshow.episodes.first!.id
                        proxy.scrollTo(state.scrollepisodeID, anchor: .center)
                    }
                }
            } else {
                Text("No episodes available")
                    .foregroundColor(.secondary)
            }
            
            if let error = state.error {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            refreshShowDetails()
        }
        .onChange(of: myshow.id) { _, _ in
            refreshShowDetails()
        }
        .onDisappear {
            myshowsmodel.saveMy()
        }
        .padding()
    }
    func loadShows(query: Int) async {
        guard let url = URL(string: "https://api.tvmaze.com/shows/\(query)?embed=episodes") else {
            state.error = "Invalid URL"
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let results = try JSONDecoder().decode(ShowBase.self, from: data)
            state.show = results
        } catch {
            print(error.localizedDescription)
            state.error = error.localizedDescription
        }
    }
    private func refreshShowDetails() {
        Task {
            await loadShows(query: myshow.id)
            state.apollo = myshow.Apollo
            state.kodi = myshow.Kodi
            state.watching = myshow.Watching
            state.rating = myshow.Rating
            state.comments = myshow.comments ?? ""
            setOriginals()
            dismissKeyboard()
            if myshow.episodes.count > 0 {
                state.scrollepisodeID = myshow.episodes[0].id
            }
        }
    }
    private func setOriginals() {

        state.originalApollo = state.apollo
        state.originalKodi = state.kodi
        state.originalWatching = state.watching
        state.originalRating = state.rating
        state.originalComments = state.comments

    }
}

#Preview {
    ShowDetailView(myshow: MyShow())
        .environmentObject(MyShowsModel())
}

