//
//  MyCalendar.swift
//  tvWatchedEmbedded
//
//  Created by Brian Quick on 2025-11-04.
//

import SwiftUI
import Combine

final class MyCalendarViewState: ObservableObject {
    // number of episodes that will be listed on a show
    @Published var episodecnt = 2
    
    // Holds any error messages during loading (not yet used)
    @Published var error: String?
}
struct MyCalendarView: View {
    @EnvironmentObject var myshowsmodel: MyShowsModel
    @StateObject private var state = MyCalendarViewState()
    
    @Environment(\.selectedTab) var selectedTab
    @Environment(\.selectedShowID) var selectedShowID
    

    
    var body: some View {
        
        VStack {
            HStack {
                Text("My Calendar \(myshowsmodel.MyShows.count)")
                Text("AllBaseShows: \(myshowsmodel.allBaseShows.count)")
//                Text("showsWithFutureEpisodesStrict: \(myshowsmodel.showsWithFutureEpisodesStrict.count)")
                Spacer()
                Text("Number of episodes to showing \(state.episodecnt):")
                Stepper(value: $state.episodecnt, in: 1...30) {
                    EmptyView() // No label inside Stepper, so only the +/- buttons show
                }
                .frame(width: 100) // Optional: fix width of Stepper to keep it tight
                
            }
            .padding(.horizontal)
            if !myshowsmodel.allBaseShowsComplete {
                ProgressView("Loading shows…")
            } else {
            List(myshowsmodel.showsWithFutureEpisodesStrict(), id: \.id) { myShow in
                // nes let and list end
                VStack(alignment: .leading) {
                    // ai start only list last episode watched with upcoming episodes after that episode
                    if let lastWatched = myShow.episodes
                        .filter({ !$0.dateWatched.isEmpty })
                        .max(by: {
                            ($0.season ?? 0, $0.number ?? 0) < ($1.season ?? 0, $1.number ?? 0)
                        }) {
                        
                        // Use lastWatched episode here
                        let thisEpisodeName = baseShowEpisodeName(showid: myShow.id, season: lastWatched.season ?? 0, episode: lastWatched.number ?? 0)
                        
                        
                        if let baseShow = myshowsmodel.allBaseShows.first(where: { $0.id == myShow.id }) {
                            let upcoming = myshowsmodel.upcomingEpisodes(after: lastWatched, in: baseShow)
                            if !upcoming.isEmpty {
                                HStack {
                                    Text(myShow.name)
                                        .font(.title)
                                    Spacer()
                                    if myShow.Watching {
                                        Button("Watching") {
                                            print("Today..............")
                                            selectedTab?.wrappedValue = 0
                                            selectedShowID?.wrappedValue = myShow.id
                                        }
                                        .buttonStyle(myButtonStyle())
                                    }
                                    if myShow.Apollo {
                                        Button("Apollo") {
                                            print("Today..............")
                                            selectedTab?.wrappedValue = 0
                                            selectedShowID?.wrappedValue = myShow.id
                                        }
                                        .buttonStyle(myButtonStyle())
                                    }
                                    if myShow.Kodi {
                                        Button("Koli") {
                                            print("Today..............")
                                            selectedTab?.wrappedValue = 0
                                            selectedShowID?.wrappedValue = myShow.id
                                        }
                                        .buttonStyle(myButtonStyle())
                                    }
                                }
                                HStack {
                                    Text("Watched: S\(lastWatched.season ?? 0)E\(lastWatched.number ?? 0) \(thisEpisodeName)")
                                        .font(.subheadline)
                                    Spacer()
                                    Text("\(upcoming.count) episodes coming")
                                }
                                
                                let limitedupcoming = Array(upcoming.prefix(state.episodecnt))
                                ForEach(limitedupcoming, id: \.id) { ep in                                        Text("Upcoming: id: \(ep.id)  S\(ep.season)E\(ep.episode) - \(ep.title) (Airdate: \(ep.airdate))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        } // end of if
        }
        // Load all base shows when view appears
//        .onAppear {
//            Task {
//                await myshowsmodel.loadAllShows()
//            }
//        }
    }
    func baseShowEpisodeName(showid: Int, season: Int, episode: Int) -> String {
        guard let baseshow = myshowsmodel.allBaseShows.first(where: {$0.id ?? 0 == showid}) else { return ""}
        guard let baseepisodes = baseshow.embedded?.episodes else { return ""}
        if let episode = baseepisodes.first(where: {$0.season == season && $0.number == episode}) {
            return episode.name ?? ""
        }
        return ""
    }

    



}

// MARK: - Dummy Data Models for Preview and Compilation

// Base show model representing the original show data (episodes)
struct ShowBaseAI: Identifiable {
    let id: Int
    let name: String
    let episodes: [EpisodeBase]
}

struct EpisodeBase: Identifiable {
    let id: Int
    let season: Int
    let episode: Int
    let title: String
    let airdate: String // Assume format "YYYY-MM-DD"
}


//// Dummy MyShowsModel for compilation and preview purposes
//class MyShowsModelPreview: ObservableObject {
//    @Published var MyShows: [MyShow] = []
//}

#Preview {
    MyCalendarView()
        .environmentObject(MyShowsModel())
        .environment(\.selectedTab, .constant(0))
        .environment(\.selectedShowID, .constant(nil))
}
