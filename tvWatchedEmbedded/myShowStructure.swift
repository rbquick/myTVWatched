//
//  myShowStructure.swift
//  tvWatchedEmbedded
//
//  Created by Brian Quick on 2025-10-29.
//

import Foundation

struct myShow: Identifiable {
    
    let id: Int
    let title: String
    
    internal init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
    
}
