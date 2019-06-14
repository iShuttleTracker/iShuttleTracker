//
//  Vehicle.swift
//  ShuttleTrackeriOS
//
//  Created by Matt Czyr on 10/1/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

var vehicles: [Int:Vehicle] = [:]

struct Vehicle: CustomStringConvertible {
    
    var id = 0
    var name = ""
    var created = ""
    var updated = ""
    var enabled = false
    var tracker_id = ""
    var last_update = Update()!
    var closest_point_index = 0
    
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
                print("Unknown (key/value) pair in a vehicle: (\(key)/\(value))")
            }
        }
//        print("Finished JSON initialization for vehicle \(self.id)")
    }
    
    /**
     Updates the Vehicle.
     - Parameter update: The latest Update for this Vehicle.
     */
    mutating func update(update: Update) {
        last_update = update
        let start = Point(update: last_update)
        var minIndex = 0
        var minDistance = 0.0
        for i in 0..<last_update.route.points.count {
            if last_update.route.points[i] == start {
                minIndex = i
                break
            } else {
                let distance = last_update.route.points[i].distanceFrom(p: start)
                if distance < minDistance {
                    minIndex = i
                    minDistance = distance
                }
            }
        }
        closest_point_index = minIndex
    }
    
    /**
     Estimates the current position of this Vehicle based on the previous Updates received.
     - Returns: A Point corresponding to the current estimated position for this Vehicle.
     */
    func estimateCurrentPosition() -> Point {
        // 0.621371192 is the same constant used in the web app to initially convert from
        // KM/H to MPH when pulling from the data feed, so we're not losing any precision
        let metersPerSecond = (last_update.speed / 0.621371192) / 3.6
        // predictedDistance presents the distance that the shuttle would have traveled since
        // the last update if its speed remained the same
        let predictedDistance = metersPerSecond * secondsSince(update: last_update)
        // start represents the closest point in the route to the the vehicle's actual position
        let start = Point(update: last_update)
        var elapsedDistance = 0.0
        var index = closest_point_index
        while elapsedDistance < predictedDistance {
            elapsedDistance += start.distanceFrom(p: last_update.route.points[index])
            index += 1
            if index >= last_update.route.points.count {
                index = 0
            }
        }
        return last_update.route.points[index]
    }
    
    /**
     Gets the rotation for marker display.
     - Returns: The Vehicle's rotation for display.
     */
    func getRotation() -> Int {
        return last_update.heading - 45;
    }
    
    /**
     Converts a time represented by a String to a Date.
     - Parameter time: The time to convert, in the form "yyyy-MM-dd'T'HH:mm:ss.ZZZZZZ'Z'".
     - Returns: A Date object representing the given String time, or nil if the String does not represent
     a properly formatted time.
     */
    func convertTime(time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ZZZZZZ'Z'"
        return formatter.date(from: time)
    }
    
    /**
     Returns the amount of time that has passed since the given Update was received.
     - Parameter update: The update to return the time since.
     - Returns: A TimeInterval (Double) representing the amount of time in seconds since the update
     was received.
     */
    func secondsSince(update: Update) -> TimeInterval {
        return convertTime(time: update.time)!.timeIntervalSinceNow
    }
    
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
 */
func initVehicles() {
    let data = fetchVehicles()
    let json = try? JSONSerialization.jsonObject(with: data, options: []) as! NSArray
    for unique in json! {
        let vehicle = Vehicle(json:unique as! NSDictionary)
        vehicles[vehicle!.id] = vehicle
    }
}
