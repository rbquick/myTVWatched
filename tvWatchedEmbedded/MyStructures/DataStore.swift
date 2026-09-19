//
//  DataStore.swift
//  tvWatchedEmbedded
//
//  Created by Brian Quick on 2025-10-31.
//

import Foundation

class DataStore {
    static let shared = DataStore()
    private init() {}

    // File name in iCloud container
    private let fileName = "myshows.json"

    // URL to the iCloud container documents directory
    private var iCloudDocumentsURL: URL? {
        FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }

    // Full file URL for myshows.json in iCloud
    private var fileURL: URL? {
        iCloudDocumentsURL?.appendingPathComponent(fileName)
    }
    private var backupURL: URL? {
            let filedate = myDateFormatter(inDate: Date())
            let filename = "myshows-\(filedate).json"
          return iCloudDocumentsURL?.appendingPathComponent(filename)
       }

    // Save shows array to iCloud JSON file
    func backupShows<T: Encodable>(_ shows: [T]) {
        guard let fileURL = backupURL else {
            print("iCloud container not available")
            return
        }
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(shows)
            // Ensure the Documents directory exists
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            // Write data to file URL with iCloud ubiquity
            try data.write(to: fileURL, options: [.atomic])
            print("Saved shows to iCloud at \(fileURL)")
        } catch {
            print("Error saving shows to iCloud:", error)
        }
    }

    // Save shows array to iCloud JSON file
    func saveShows<T: Encodable>(_ shows: [T]) {
        guard let fileURL = fileURL else {
            print("iCloud container not available")
            return
        }
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(shows)
            // Ensure the Documents directory exists
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            // Write data to file URL with iCloud ubiquity
            try data.write(to: fileURL, options: [.atomic])
            print("Saved shows to iCloud at \(fileURL)")
        } catch {
            print("Error saving shows to iCloud:", error)
        }
    }

    // Load shows array from iCloud JSON file
    func loadShows<T: Decodable>(_ type: T.Type) -> T? {
        guard let fileURL = fileURL else {
            print("iCloud container not available")
            return nil
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let shows = try decoder.decode(T.self, from: data)
            print("Loaded shows from iCloud at \(fileURL)")
            return shows
        } catch {
            print("Error loading shows from iCloud:", error)
            return nil
        }
    }
}
