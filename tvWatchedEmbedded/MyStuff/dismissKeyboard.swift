//
//  dismissKeyboard.swift
//  tvWatchedEmbedded
//
//  Created by Brian Quick on 2026-01-18.
//
// 2026-01-18 there is not swiftui function to do this
//              so using the UIKit is "The standard workaround" as of this date

import UIKit
func dismissKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
