//
//  Update.swift
//  ShuttleTrackeriOS
//
//  Created by Matt Czyr on 10/2/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

struct Update {
    
    var id = 0
    var tracker_id = ""
    var latitude = 0.0
    var longitude = 0.0
    var heading = 0
    var speed = 0.0
    var time = ""
    var created = ""
    var vehicle_id = 0
    var route_id = 0
    
    // Initialize update data from JSON dictionary
    init?(json: NSDictionary){
        for (key, value) in json {
            switch key as? NSString {
            case "id":
                self.id = (value as! Int)
            case "tracker_id":
                self.tracker_id = (value as! String)
            case "latitude":
                self.latitude = (value as! Double)
            case "longitude":
                self.longitude = (value as! Double)
            case "heading":
                self.heading = (value as! Int)
            case "speed":
                self.speed = (value as! Double)
            case "time":
                self.time = (value as! String)
            case "created":
                self.created = (value as! String)
            case "vehicle_id":
                self.vehicle_id = (value as! Int)
            case "route_id":
                if let id = value as? Int {
                    self.route_id = id
                } else {
                    self.route_id = -1
                }
            default:
                // This should never happen
                print("\(key)")
            }
        }
        print("Finished JSON initialization for update \(self.id)")
    }
    
}

extension Update:CustomStringConvertible {
    var description:String {
        return """
               ID: \(self.id)
               Tracker ID: \(self.tracker_id)
               Latitude: \(self.latitude)
               Longitude: \(self.longitude)
               Heading: \(self.heading)
               Speed: \(self.speed)
               Time: \(self.time)
               Created: \(self.created)
               Vehicle ID: \(self.vehicle_id)
               Route ID: \(self.route_id)
               """
    }
}

/**
 Fetches update data from shuttles.rpi.edu/updates.
 - Returns: The raw Data object fetched
 */
func fetchUpdates() -> Data {
    let urlString = URL(string: "https://shuttles.rpi.edu/updates")
    let semaphore = DispatchSemaphore(value: 0)
    var updatesData = Data()
    if let url = urlString {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let usableData = data {
                    updatesData = usableData
                    semaphore.signal()
                }
            }
        }
        task.resume()
        semaphore.wait()
    }
    return updatesData
}

/**
 Initializes updates fetched from fetchUpdates().
 - Returns: An array of initialized Updates
 */
func initUpdates() -> [Update] {
    var updates:[Update] = []
    let data = fetchUpdates()
    let json = try? JSONSerialization.jsonObject(with: data, options: []) as! NSArray
    for unique in json! {
        print("Creating new update...")
        let update = Update(json:unique as! NSDictionary)
        print(update!)
        updates.append(update!)
    }
    
    return updates
}
