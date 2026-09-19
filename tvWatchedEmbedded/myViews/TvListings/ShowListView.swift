//
//  ShowListView.swift
//  tvWatchedEmbedded
//
//  Created by Brian Quick on 2025-10-29.
//

import SwiftUI
import Combine

final class ShowListState: ObservableObject {
    @Published var selectedShow: Int? = nil
    @Published var showingSearch: Bool = false
    @Published var searchText: String = ""
    @Published var selectedSource: ShowSourceFilter = .all
}

enum ShowSourceFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case apollo = "Apollo"
    case kodi = "Kodi"
    case watching = "Watching"
    var id: String { self.rawValue }
}

struct ListShowLine: View {
    let myshow: MyShow
    var body: some View {
        VStack(alignment:. leading) {
            Text(myshow.name)
            HStack {
                Spacer()
                
                Text("\(myshow.Apollo ? "Apollo" : "Kodi")")
            }
        }
    }
}

struct ShowListView: View {
    @EnvironmentObject var myshowsmodel: MyShowsModel
    @Environment(\.selectedShowID) var selectedShowID
    
    @StateObject private var state = ShowListState()

    var filteredShows: [MyShow] {
        let sourceFiltered: [MyShow]
        switch state.selectedSource {
        case .all:
            sourceFiltered = myshowsmodel.MyShows
        case .apollo:
            sourceFiltered = myshowsmodel.MyShows.filter { $0.Apollo }
        case .kodi:
            sourceFiltered = myshowsmodel.MyShows.filter { $0.Kodi }
        case .watching:
            sourceFiltered = myshowsmodel.MyShows.filter { $0.Watching }
        }
        if myshowsmodel.searchText.isEmpty {
            return sourceFiltered
        } else {
            return sourceFiltered.filter { $0.name.localizedCaseInsensitiveContains(myshowsmodel.searchText) }
        }
    }

    var body: some View {
        NavigationSplitView {
            VStack {
                if !myshowsmodel.searchIsShowing {
                    mySearchView()
                }
                Picker("Source", selection: $state.selectedSource) {
                    ForEach(ShowSourceFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                ScrollViewReader { proxy in
                    
                    
                    List(selection: $state.selectedShow) {
                        ForEach(filteredShows) { myshow in
                            ListShowLine(myshow: myshow)
                                .tag(myshow.id)
                        }
                        .onDelete { offsets in
                            // Map offsets from filteredShows to IDs
                            let idsToDelete: [Int] = offsets.compactMap { index in
                                guard filteredShows.indices.contains(index) else { return nil }
                                return filteredShows[index].id
                            }

                            // Build an IndexSet for the underlying data source based on IDs
                            var underlyingOffsets = IndexSet()
                            for (idx, show) in myshowsmodel.MyShows.enumerated() {
                                if idsToDelete.contains(show.id) {
                                    underlyingOffsets.insert(idx)
                                }
                            }

                            // Perform deletion on the underlying model using mapped indices
                            myshowsmodel.delete(at: underlyingOffsets)

                            // Clear selection if it was deleted
                            if let selected = state.selectedShow, idsToDelete.contains(selected) {
                                state.selectedShow = nil
                            }
                        }
                    }
                    .navigationTitle("Shows")
//                    .searchable(text: $searchText, prompt: "Filter shows")

                    .toolbar {
                        Button("New Shows") {
                            state.showingSearch = true
                        }
                    }
                    .onAppear {
                        if let selID = selectedShowID?.wrappedValue, filteredShows.contains(where: { $0.id == selID }) {
                            proxy.scrollTo(selID, anchor: .center)
                            state.selectedShow = selID
                        }
                    }
                    .onChange(of: (selectedShowID?.wrappedValue) as Int?) { newID in
                        if let selID = newID, filteredShows.contains(where: { $0.id == selID }) {
                            proxy.scrollTo(selID, anchor: .center)
                            state.selectedShow = selID
                        }
                    }

                }
            }
        } detail: {
            if let selected = state.selectedShow {
                ShowDetailView(myshow: myshowsmodel.getmyshow(myshowid: selected))
            } else {
                Text("Select a show")
                    .foregroundStyle(.secondary)
            }
        }
        // fixing state
        // 2026-09-18 i may have hurt this foundName?
        .sheet(isPresented: $state.showingSearch) {
            ShowSearchView() { foundName in
                state.showingSearch = false
            }
            .environmentObject(myshowsmodel)
        }
        .searchable(text: $state.searchText, prompt: "Filter shows")
    }
}

#Preview {
    ShowListView()
        .environmentObject(MyShowsModel())
        .environment(\.selectedShowID, .constant(nil))
}
