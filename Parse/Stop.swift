//
//  Stop.swift
//  ShuttleTrackeriOS
//
//  Created by Matt Czyr on 10/4/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

var stops: [Int:Stop] = [:]

struct Stop: CustomStringConvertible {
    
    var id = 0
    var latitude = 0.0
    var longitude = 0.0
    var created = ""
    var updated = ""
    var name = ""
    var desc = ""
    
    /**
     Initializes a new Stop with default values.
     - Returns: A new Stop with default values.
     */
    init?() {
    }
    
    /**
     Initializes a new Stop.
     - Returns: A new Stop from the data contained in the dictionary
     */
    init?(json: NSDictionary) {
        for (key, value) in json {
            switch key as? NSString {
            case "id":
                self.id = (value as! Int)
            case "latitude":
                self.latitude = (value as! Double)
            case "longitude":
                self.longitude = (value as! Double)
            case "created":
                self.created = (value as! String)
            case "updated":
                self.updated = (value as! String)
            case "name":
                self.name = (value as! String)
            case "description":
                self.desc = (value as! String)
            default:
                // This should never happen
                print("Unknown (key/value) pair in a stop: (\(key)/\(value))")
            }
        }
    }
    
    var description: String {
        return """
        ID: \(self.id)
        Latitude: \(self.latitude)
        Logitude: \(self.longitude)
        Created: \(self.created)
        Updated: \(self.updated)
        Name: \(self.name)
        Description: \(self.desc)
        """
    }

}

/**
 Fetches stop data from shuttles.rpi.edu/stops and writes it to
 stops.json in the application's documents directory.
 - Returns: A String containing the raw JSON data fetched
 */
func fetchStops() -> String {
    let urlString = URL(string: "https://shuttles.rpi.edu/stops")
    let semaphore = DispatchSemaphore(value: 0)
    var stopsData = ""
    if let url = urlString {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let usableData = data {
                    let dataString = String(data: usableData, encoding: .utf8)!
                    writeJSON(filename: "stops.json", data: dataString)
                    stopsData = dataString
                    semaphore.signal()
                }
            }
        }
        task.resume()
        semaphore.wait()
    }
    return stopsData
}

/**
 Initializes stops from stops.json if it exists, otherwise will
 call fetchStops() fetch stop data and writes it to stops.json.
 */
func initStops() {
    let file = "stops.json"
    let dataString = !fileExists(filename: file) ? fetchStops() : readJSON(filename: file)
    let data = dataString.data(using: .utf8)!
    let json = try? JSONSerialization.jsonObject(with: data, options: []) as! NSArray
    for unique in json! {
        let stop = Stop(json:unique as! NSDictionary)
        for (id, route) in routes {
            if route.stop_ids.contains(stop!.id) {
                routes[id]!.stops[stop!.id] = stop
            }
        }
        stops[stop!.id] = stop
    }
}

