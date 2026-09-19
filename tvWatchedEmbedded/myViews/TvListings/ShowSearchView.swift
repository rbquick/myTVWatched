//
//  ShowSearchView.swift
//  tvWatchedEmbedded
//
//  Created by Brian Quick on 2025-10-30.
//

import SwiftUI
import Combine

final class ShowSearchViewState: ObservableObject {
    @Published var searchText: String = ""
    @Published var show: ShowBase = ShowBase()
    @Published var error: String?
}
struct ShowSearchView: View {
    
    @EnvironmentObject var myshowsmodel: MyShowsModel
    @StateObject private var state = ShowSearchViewState()
    var completion: (String?) -> Void
// fixing state
//    init(state: @autoclosure @escaping () -> ShowContentViewState = ShowContentViewState(), completion: @escaping (String?) -> Void) {
//        _state = StateObject(wrappedValue: state())
//        self.completion = completion
//    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("Search Shows")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .top)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                
                Spacer()
                HStack {
                    Button("Search") {
                        Task {
                            await getShows(query: state.searchText)
                        }
                    }
                    .padding()
                    if state.show.name != nil {
                        Button("Use") {
                            // Simulate search logic; return searchText if found, or nil if not found
                            let found = state.searchText.isEmpty ? nil : state.searchText
                            if !myshowsmodel.showOnFile(myshowid: state.show.id ?? 1) {
                                let episodes: [MyEpisode] = []
                                let newshow = MyShow(id: state.show.id ?? 1, name: state.show.name ?? "wrong", episodes: episodes)
                                myshowsmodel.addShow(newshow)
                                myshowsmodel.saveMy()
                            }
                            completion(found)
                        }
                        .padding()
                    }
                    
                    Button("Cancel") {
                        completion(nil)
                    }
                    .padding()
                }
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
                    if state.show.name != nil {
                        VStack {
                            Text("Show found: \(state.show.name ?? "Not found")")
                            Text("Premiered: \(state.show.premiered ?? "Not found")")
                            if myshowsmodel.showOnFile(myshowid: state.show.id ?? 1) {
                                Text("Already added to list")
                                    .foregroundColor(Color.red)
                            }
                        }
                    }
                }
                TextField("Enter show name", text: $state.searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                    Spacer()
            }
        }
    }
}

#Preview {
    ShowSearchView(completion: { _ in })
        .environmentObject(MyShowsModel())
}

extension ShowSearchView {
    func getShows(query: String) async  {
            guard let url = URL(string: "https://api.tvmaze.com/singlesearch/shows?q=\(query)&embed=episodes") else {
                state.error = "Invalid URL"
                return
            }
            do {
                let (data, _) = try  await URLSession.shared.data(from: url)
                let results = try JSONDecoder().decode(ShowBase.self, from: data)
                state.show = results
            } catch {
                state.error = error.localizedDescription
            }
        }
}
