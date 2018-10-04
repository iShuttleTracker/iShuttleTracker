//
//  Vehicle.swift
//  ShuttleTrackeriOS
//
//  Created by Matt Czyr on 10/1/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

struct Vehicle {
    
    var id = 0
    var name = ""
    var created = ""
    var updated = ""
    var enabled = false
    var tracker_id = ""
    
    init?(json: NSDictionary) {
        // Catch vehicle data
        for (key, value) in json {
            switch key as? NSString {
            case "id":
                self.id = (value as! Int)
            case "name":
                self.name = (value as! String)
            case "created":
                self.created = (value as! String)
            case "updated":
                self.updated = (value as! String)
            case "enabled":
                self.enabled = (value as! Bool)
            case "tracker_id":
                self.tracker_id = (value as! String)
            default:
                // This should never happen
                print("\(key)")
            }
        }
        print("Finished JSON initialization for vehicle \(self.id)")
    }
    
    func printVehicle() {
        print("ID: \(self.id)")
        print("Name: \(self.name)")
        print("Created: \(self.created)")
        print("Updated: \(self.updated)")
        print("Enabled: \(self.enabled)")
        print("Tracker ID: \(self.tracker_id)")
    }
}

func fetchVehicles() -> [Vehicle] {
    var vehicles:[Vehicle] = [];
    let urlString = URL(string: "https://shuttles.rpi.edu/vehicles")
    
    if let url = urlString {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let usableData = data {
                    let json = try? JSONSerialization.jsonObject(with: usableData, options: []) as! NSArray

                    for unique in json! {
                        print("Creating new vehicle...")
                        let vehicle = Vehicle(json:unique as! NSDictionary)
                        vehicle?.printVehicle()
                        vehicles.append(vehicle!)
                    }
                }
            }
        }
        task.resume()
    }
    
    return vehicles
}
