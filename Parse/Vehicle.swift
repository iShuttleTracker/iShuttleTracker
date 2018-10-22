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
    var last_update = Update()!
    
    /**
     Initializes a new Vehicle.
     - Returns: A new Vehicle from the data contained in the dictionary
     */
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
                print("Unknown (key/value) pair: (\(key)/\(value))")
            }
        }
        print("Finished JSON initialization for vehicle \(self.id)")
    }
    
    /**
     Updates the Vehicle.
     - Parameter update: The latest Update for this Vehicle.
     */
    mutating func update(update: Update) {
        last_update = update
    }
    
    /**
     Attempts to update the Vehicle.
     - Parameter updates: An array of Updates that may contain an Update for this Vehicle.
     */
    mutating func updateFrom(updates: [Update]) {
        for u in updates {
            if u.vehicle_id == id {
                update(update: u)
            }
        }
    }
    
    /**
     Gets the rotation for marker display.
     - Returns: The Vehicle's rotation for display.
     */
    func getRotation() -> Int {
        return last_update.heading - 45;
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

/**
 Fetches vehicle data from shuttles.rpi.edu/vehicles.
 - Returns: The raw Data object fetched
 */
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

/**
 Initializes vehicles fetched from fetchVehicles().
 - Returns: An array of initialized Vehicles
 */
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
