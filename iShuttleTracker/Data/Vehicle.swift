//
//  Vehicle.swift
//  ShuttleTrackeriOS
//
//  Created by Matt Czyr on 10/1/18.
//  Copyright © 2018 iShuttleTracker. All rights reserved.
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
    }
    
    /**
     Updates the Vehicle.
     - Parameter update: The latest Update for this Vehicle.
     */
    mutating func update(update: Update) {
        last_update = update
        let start = last_update.point
        var minIndex = 0
        var minDistance = -1.0
        for i in 0..<last_update.route.points.count {
            if last_update.route.points[i] == start {
                minIndex = i
                break
            } else {
                let distance = last_update.route.points[i].distanceFrom(p: start)
                if distance < minDistance || minDistance < 0.0 {
                    minIndex = i
                    minDistance = distance
                }
            }
        }
        closest_point_index = minIndex
    }
    
    /**
     Estimates the current position of this Vehicle based on the previous Updates received.
     - Returns: An index corresponding to the Point the shuttle should be at on its current route.
     */
    func estimateCurrentPosition() -> Int {
        // Seems like speeds from the datafeed are actually in KM/H, not MPH
        let metersPerSecond = last_update.speed / 3.6
        // predictedDistance represents the distance that the shuttle would have traveled since
        // the last update if its speed remained the same
        let predictedDistance = metersPerSecond * secondsSince(update: last_update)
        //print("Predicted distance for vehicle \(vehicle_id): \(predictedDistance)")
        var elapsedDistance = 0.0
        var index = closest_point_index
        while elapsedDistance < predictedDistance {
            let prevIndex = index
            index += 1
            if index >= last_update.route.points.count {
                index = 0
            }
            elapsedDistance += last_update.route.points[index].distanceFrom(p: last_update.route.points[prevIndex])
        }
        return index
    }
    
    /**
     Estimates how long it will take this Vehicle to reach the given Stop, depending on its
     current velocity.
     - Parameter stop: The stop the vehicle needs to reach
     - Returns: An estimation of how long it will take this Vehicle to reach the Stop, in seconds,
     or -1.0 if the stop is not on this vehicle's route
     */
    func secondsUntilReachesStop(stop: Stop) -> Double {
        if last_update.route.hasStop(stop: stop) {
            let stopOnRoute: StopOnRoute = StopOnRoute(stop: stop, route: last_update.route)
            return secondsUntilReachesPosition(position: last_update.route.points[closestPointIndexToStopOnRoute[stopOnRoute]!])
        }
        return -1.0
    }
    
    /**
     Estimates how long it will take this Vehicle to reach the given Point, depending on its
     current velocity.
     - Parameters:
       - position: The position the Vehicle needs to reach
     - Returns: An estimation of how long it will take this Vehicle to reach the Point, in seconds
     */
    func secondsUntilReachesPosition(position: Point) -> Double {
        let metersPerSecond = last_update.speed / 3.6
        var seconds = 0.0
        var index = closest_point_index
        while last_update.route.points[index] != position {
            let prevIndex = index
            index += 1
            if index >= last_update.route.points.count {
                index = 0
            }
            seconds += last_update.route.points[index].distanceFrom(p: last_update.route.points[prevIndex]) / metersPerSecond
        }
        
        return seconds
    }
    
    /**
     Gets the rotation for marker display.
     - Returns: The Vehicle's rotation for display.
     */
    func getRotation() -> Int {
        return last_update.getRotation()
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
    vehicles.removeAll()
    for unique in json! {
        let vehicle = Vehicle(json:unique as! NSDictionary)
        vehicles[vehicle!.id] = vehicle
    }
}
