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
    
    // Initialize vehicle data from JSON dictionary
    init?(json: NSDictionary) {
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
    
}
extension Vehicle:CustomStringConvertible {
    var description:String {
        return  """
                  ID: \(self.id)
                  Name: \(self.name)
                  Created: \(self.created)
                  Updated: \(self.updated)
                  Enabled: \(self.enabled)
                  Tracker ID: \(self.tracker_id)
                  """
    }
}

// Fetches vehicle data from shuttles.rpi.edu/vehicles and returns
// the raw data.
func fetchVehicles() -> Data {
    let urlString = URL(string: "https://shuttles.rpi.edu/vehicles")
    let semaphore = DispatchSemaphore(value: 0)
    var vehiclesData = Data()
    if let url = urlString {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let usableData = data {
                    vehiclesData = usableData
                    semaphore.signal()
                }
            }
        }
        task.resume()
        semaphore.wait()
    }
    return vehiclesData
}

// Initializes vehicles fetched through fetchVehicles() and
// returns an array of the vehicles.
func initVehicles() -> [Vehicle] {
    var vehicles:[Vehicle] = []
    let data = fetchVehicles()
    let json = try? JSONSerialization.jsonObject(with: data, options: []) as! NSArray
    for unique in json! {
        print("Creating new vehicle...")
        let vehicle = Vehicle(json:unique as! NSDictionary)
        print(vehicle!)
        vehicles.append(vehicle!)
    }
    
    return vehicles
}
