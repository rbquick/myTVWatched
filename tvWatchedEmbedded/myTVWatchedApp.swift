//
//  tvWatchedEmbeddedApp.swift
//  tvWatchedEmbedded
//
//  Created by Brian Quick on 2025-10-29.
//
// 2026-09-19 03:47 trying to get this thing running

import SwiftUI
import Combine

//struct SelectedTabKey: EnvironmentKey {
//    static let defaultValue: Binding<Int>? = nil
//}
//
//extension EnvironmentValues {
//    var selectedTab: Binding<Int>? {
//        get { self[SelectedTabKey.self] }
//        set { self[SelectedTabKey.self] = newValue }
//    }
//}
//
//struct SelectedShowIDKey: EnvironmentKey {
//    static let defaultValue: Binding<Int?>? = nil
//}
//
//extension EnvironmentValues {
//    var selectedShowID: Binding<Int?>? {
//        get { self[SelectedShowIDKey.self] }
//        set { self[SelectedShowIDKey.self] = newValue }
//    }
//}
final class tvWatchedEmbeddedAppState: ObservableObject {
    @Published  var selectedTab: Int = 0
    @Published  var selectedShowID: Int? = nil
}
@main
struct tvWatchedEmbeddedApp: App {
    @StateObject var myshowsmodel: MyShowsModel = MyShowsModel()
    @StateObject private var state = tvWatchedEmbeddedAppState()

    var body: some Scene {
        WindowGroup {
        if !myshowsmodel.allBaseShowsComplete {
            ProgressView("Loading shows…\(myshowsmodel.allBaseShows.count) of \(myshowsmodel.MyShows.count)")
        } else {
            TabView(selection: $state.selectedTab) {
                    ShowListView()
                        .tabItem {
                            Label("Shows", systemImage: "list.bullet")
                        }
                        .tag(0)
                    MyCalendarView()
                        .tabItem {
                            Label("Calendar", systemImage: "calendar")
                        }
                        .tag(1)
                    Scheduler()
                        .tabItem {
                            Label("Schedule", systemImage: "calendar.badge.plus")
                        }
                        .tag(2)
                    
                    Settings()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
                        .tag(3)
                }
//            .environment(\.selectedTab, $state.selectedTab)
//            .environment(\.selectedShowID, $state.selectedShowID)
                .environmentObject(myshowsmodel)
            }
        }
    }
}
