//
//  Update.swift
//  ShuttleTrackeriOS
//
//  Created by Matt Czyr on 10/2/18.
//  Copyright ¬© 2018 WTG. All rights reserved.
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
    
    init?(json: NSDictionary){
        // Catch update data
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
    
    func printUpdate() {
        print("ID: \(self.id)")
        print("Tracker ID: \(self.tracker_id)")
        print("Latitude: \(self.latitude)")
        print("Longitude: \(self.longitude)")
        print("Heading: \(self.heading)")
        print("Speed: \(self.speed)")
        print("Time: \(self.time)")
        print("Created: \(self.created)")
        print("Vehicle ID: \(self.vehicle_id)")
        print("Route ID: \(self.route_id)")
    }
}

func fetchUpdates() -> [Update] {
    var updates:[Update] = [];
    let urlString = URL(string: "https://shuttles.rpi.edu/updates")
    
    if let url = urlString {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let usableData = data {
                    let json = try? JSONSerialization.jsonObject(with: usableData, options: []) as! NSArray
                    
                    for unique in json! {
                        print("Creating new update...")
                        let update = Update(json:unique as! NSDictionary)
                        update?.printUpdate()
                        updates.append(update!)
                    }
                }
            }
        }
        task.resume()
    }
    
    return updates
}
