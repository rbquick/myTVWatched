//
//  myDateFormatter.swift
//  HandicappIOS
//
//  Created by Brian Quick on 2021-11-14.
//

import SwiftUI

func myDateFormatter(inDate: String, outFormat: String = "yyyy-MM-dd") -> Date? {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"
    let mydate = inputFormatter.date(from: inDate) ?? Date()
    return mydate
}       
func myDateFormatter(inDate: String, inFormat: String = "yyyy-MM-dd", outFormat: String = "yyyy-MM-dd") -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = inFormat
    let mydate = inputFormatter.date(from: inDate) ?? Date()
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = outFormat
    let outputDate =  outputFormatter.string(from: mydate)
    return outputDate
}
func myDateFormatter(inDate: Date, outFormat: String = "yyyy-MM-dd") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = outFormat
    return dateFormatter.string(from: inDate as Date)
}
func myDateFormatter(inDate: Date, inFormat: String = "yyyy-MM-dd", outFormat: String = "yyyy-MM-dd") -> String {
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = outFormat
    let outputDate =  outputFormatter.string(from: inDate)
    return outputDate
}
func myDateIncrement(inDate: String, inFormat: String = "yyyy-MM-dd", outFormat: String = "yyyy-MM-dd") -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = inFormat
    let mydate = inputFormatter.date(from: inDate) ?? Date()
    let incrementedDate = Calendar.current.date(byAdding: .day, value: 1, to: mydate)!
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = outFormat
    let outputDate =  outputFormatter.string(from: incrementedDate)
    return outputDate
}
