//
//  myEnv.swift
//  myTVWatched
//
//  Created by Brian Quick on 2026-09-19.
//

import SwiftUI
import Combine

struct SelectedTabKey: EnvironmentKey {
    static let defaultValue: Binding<Int>? = nil
}

struct SelectedShowIDKey: EnvironmentKey {
    static let defaultValue: Binding<Int?>? = nil
}

extension EnvironmentValues {
    var selectedTab: Binding<Int>? {
        get { self[SelectedTabKey.self] }
        set { self[SelectedTabKey.self] = newValue }
    }

    var selectedShowID: Binding<Int?>? {
        get { self[SelectedShowIDKey.self] }
        set { self[SelectedShowIDKey.self] = newValue }
    }
}

class myEnv: ObservableObject {
    init(selectedTab: Int = 0, selectedShowID: Int? = nil) {
        self.selectedTab = selectedTab
        self.selectedShowID = selectedShowID
    }

    @Published var selectedTab: Int
    @Published var selectedShowID: Int?
}
