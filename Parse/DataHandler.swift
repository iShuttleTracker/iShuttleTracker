//
//  CacheJSON.swift
//  ShuttleTrackeriOS
//
//  Created by Matt Czyr on 10/4/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

/**
 Checks whether or not a file exists in the application's documents
 directory.  If the file does not exist, the data will need to be
 fetched and written.
 - Parameter filename: The name of the file to check the existance of,
   relative to the application's documents directory
 - Returns: Whether or not the file exists
 */
func fileExists(filename: String) -> Bool {
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(filename)
        return FileManager.default.fileExists(atPath: fileURL.absoluteString)
    }
    return false
}

/**
 Writes JSON data to a given file in the application's documents directory.
 - Parameters:
   - filename: The name of the file to write to, relative to the
     application's documents directory
   - data: The data to the write to the file
 */
func writeJSON(filename: String, data: String) {
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(filename)
        do {
            try data.write(to: fileURL, atomically: false, encoding: .utf8)
        } catch let error as NSError {
            print("Error writing JSON data to \(filename):")
            print(error)
        }
    }
}

/**
 Reads JSON data from the file and returns it as a String.
 - Parameter filename: The name of the file to write to, relative to the
   application's documents directory
 - Returns: A String corresponding to the contents of the file. Returns an
   empty String if there is an error reading the file.
 */
func readJSON(filename: String) -> String {
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(filename)
        do {
            let routeText = try String(contentsOf: fileURL, encoding: .utf8)
            return routeText
        } catch let error as NSError {
            print("Error reading JSON data from \(filename):")
            print(error)
        }
    }
    return ""
}
