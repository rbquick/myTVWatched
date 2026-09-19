//
//  Settings.swift
//  tvWatchedEmbedded
//
//  Created by Brian Quick on 2025-11-22.
//

import SwiftUI

struct Settings: View {
    
    @EnvironmentObject var myshowsmodel: MyShowsModel
    var body: some View {
        Text("Backup all shows")
        Button("Backup") {
                                print("Button Backup shows")
            DataStore.shared.backupShows(myshowsmodel.MyShows)
                            }
        .buttonStyle(myButtonStyle())
    }
}

#Preview {
    Settings()
}
