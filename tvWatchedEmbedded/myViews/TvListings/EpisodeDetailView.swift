//
//  EpisodeDetailView.swift
//  tvWatchedEmbedded
//
//  Created by Brian Quick on 2025-10-29.
//

import SwiftUI

struct EpisodeDetailView: View {
    let myshowid: Int
    let episode: Episodes
    @EnvironmentObject var myshowsmodel: MyShowsModel
    @State var isOnFile: Bool = false
    @State var isOnSummary: Bool = false
    
    // State for selected date as Date type
    @State  var selectedDate: Date = Date()
    // For showing or hiding the picker
    @State  var showDatePicker: Bool = false
    
    var body: some View {
        VStack {
            Text(episode.name ?? "Unknown")
                .font(.headline)
            if let id = episode.id,
               let season = episode.season,
               let number = episode.number,
               let aired = episode.airdate {
                
                if let summary = episode.summary {
                    Button("Show Summary") {
                        print("Button Show Summary")
                        isOnSummary.toggle()
                    }
                    
                    if isOnSummary {
                        Text(summary)
                    }
                }
                
                Text("Season \(season), Episode \(number), Aired \(aired)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Button {
                    print("Button Watch Episode")
                    showDatePicker.toggle()
                } label: {
                    Text(isOnFile ? "Watched \(myDateFormatter(inDate: selectedDate))" : "Not Watched")
                }
                .foregroundColor(
                    isOnFile ? .red : .blue
                )
                .buttonStyle(.plain) // Avoid default button styles for text-only button
                .onAppear {
                    isOnFile = myshowsmodel.showepisodeOnFile(myshowid: myshowid, episodeid: id)
                    let dateString = myshowsmodel.showepisodeDatewatched(myshowid: myshowid, episodeid: id)
                    if let date = myDateFormatter(inDate: dateString) {
                        selectedDate = date
                    }
                }
            }
            
        }
        .alignmentGuide(VerticalAlignment.center) { _ in 0.5 }
        .sheet(isPresented: $showDatePicker) {
            myCalendar(myshowid: myshowid, episode: episode, isOnFile: $isOnFile, selectedDate: $selectedDate)
        }
    }
}

#Preview {
    let episode = Episodes(id: 1, name: "Test Episode", season: 1, number: 1, airdate: "2025-10-29")
    EpisodeDetailView(myshowid: 1, episode: episode)
        .environmentObject(MyShowsModel())
}

struct myCalendar: View {
    let myshowid: Int
    let episode: Episodes
    @Binding var isOnFile: Bool
    @Binding var selectedDate: Date
    @EnvironmentObject var myshowsmodel: MyShowsModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("Episode aired on \(episode.airdate ?? "Unknown")")
            HStack {
                Button("Save Date  ") {
                    print("Save Date............")
                    let newDateString = myDateFormatter(inDate: selectedDate)
                    _ = myshowsmodel.changeEpisode(myshowid: myshowid, episodeid: episode.id ?? 0, season: episode.season ?? 0, number: episode.number ?? 0,  datewatched: newDateString)
                    isOnFile = true
                    dismiss()
                }
                .buttonStyle(myButtonStyle())
                Button("Today") {
                    print("Today..............")
                    selectedDate = Date()
                }
                .buttonStyle(myButtonStyle())
                Button("UnWatched  ") {
                                    print("UnWatched............")
                                    myshowsmodel.deleteepisode(myshowid: myshowid, episodeid: episode.id ?? 0)
                                    isOnFile = false
                                    dismiss()
                                }
                .buttonStyle(myButtonStyle())
                Button("Cancel") {
                    print("cancel.............")
                    dismiss()
                }
                .buttonStyle(myButtonStyle())
            }
            DatePicker("Select Watched Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
        }
    }
}
