//
//  tvWatchedEmbeddedApp.swift
//  tvWatchedEmbedded
//
//  Created by Brian Quick on 2025-10-29.
//
// 2026-09-19 03:47 trying to get this thing running

import SwiftUI
import Combine


enum AppTab: Int, Hashable {
    case shows
    case calendar
    case schedule
    case settings
}

final class tvWatchedEmbeddedAppState: ObservableObject {
    @Published var selectedTab: AppTab = .shows
    @Published var selectedShowID: Int? = nil
}

@main
struct tvWatchedEmbeddedApp: App {
    @StateObject var myshowsmodel: MyShowsModel = MyShowsModel()
    @StateObject private var state = tvWatchedEmbeddedAppState()

    private var selectedTabBinding: Binding<Int> {
        Binding {
            state.selectedTab.rawValue
        } set: { rawValue in
            state.selectedTab = AppTab(rawValue: rawValue) ?? .shows
        }
    }

    var body: some Scene {
        WindowGroup {
            if !myshowsmodel.allBaseShowsComplete {
                ProgressView("Loading shows…\(myshowsmodel.allBaseShows.count) of \(myshowsmodel.MyShows.count)")
            } else {
                TabView(selection: $state.selectedTab) {
                    Tab("Shows", systemImage: "list.bullet", value: AppTab.shows) {
                        ShowListView()
                    }

                    Tab("Calendar", systemImage: "calendar", value: AppTab.calendar) {
                        MyCalendarView()
                    }

                    Tab("Schedule", systemImage: "calendar.badge.plus", value: AppTab.schedule) {
                        Scheduler()
                    }

                    Tab("Settings", systemImage: "gearshape", value: AppTab.settings) {
                        Settings()
                    }
                }
                .environment(\.selectedTab, selectedTabBinding)
                .environment(\.selectedShowID, $state.selectedShowID)
                .environmentObject(myshowsmodel)
            }
        }
    }
}
