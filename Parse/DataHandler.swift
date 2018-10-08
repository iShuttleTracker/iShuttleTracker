//
//  CacheJSON.swift
//  ShuttleTrackeriOS
//
//  Created by Matt Czyr on 10/4/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

// Returns whether or not a file with the provided filename exists in
// the application's documents directory. If the file does not exist,
// the data will need to be fetched and written.
func fileExists(filename: String) -> Bool {
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(filename)
        return FileManager.default.fileExists(atPath: fileURL.absoluteString)
    }
    return false
}

// Write JSON data to the file at the relative file path provided
// in the application's documents directory.
func writeJSON(filename: String, data: String) {
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(filename)
        do {
            try data.write(to: fileURL, atomically: false, encoding: .utf8)
            print("Finished writing JSON data to \(filename)")
            print("Absolute filepath: \(fileURL)")
        } catch let error as NSError {
            print("Error writing JSON data to \(filename):")
            print(error)
        }
    }
}

// Reads JSON data from the file and returns as a String. In the case of
// an error while writing to the file, returns an empty String.
func readJSON(filename: String) -> String {
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(filename)
        do {
            let routeText = try String(contentsOf: fileURL, encoding: .utf8)
            print("Finished reading JSON data from \(filename)")
            return routeText
        } catch let error as NSError {
            print("Error reading JSON data from \(filename):")
            print(error)
        }
    }
    return ""
}
