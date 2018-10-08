//
//  Route.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/26/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

struct Route {
    
    var color = ""
    var created = ""
    var desc = ""
    var enabled = false
    var id = 0
    var name = ""
    var points: [Point] = []
    var stop_ids: [Int] = []
    var updated = ""
    var width = 0
    
    // Initialize route data from JSON dictionary
    init?(json: NSDictionary) {
        // Need to add the points to the route
        var pointsList:[Point] = [];
        for (key, value) in json {
            switch key as? NSString {
            case "color":
                self.color = (value as! String)
            case "created":
                self.created = (value as! String)
            case "description":
                self.desc = (value as! String)
            case "enabled":
                self.enabled = (value as! Bool)
            case "id":
                self.id = (value as! Int)
            case "name":
                self.name = (value as! String)
            case "stop_ids":
                self.stop_ids = (value as! [Int])
            case "updated":
                self.updated = (value as! String)
            case "width":
                self.width = (value as! Int)
            case "points":
                // Need to parse the coordinates separately since
                // nested dictionary inside a dictionary
                for loc in (value as! NSArray) {
                    var lat: Double = 0
                    var long: Double = 0
                    for piece in (loc as! NSDictionary) {
                        if ((piece.key as! String) == "latitude") {
                            lat = piece.value as! Double
                        } else {
                            long = piece.value as! Double
                        }
                    }
                    // Append the points to the array
                    pointsList.append(Point(latitude: lat, longitude: long))
                }
            default:
                // This should never happen
                print("\(key)")
            }
        }
        // Set the points at the end
        self.points = pointsList
        print("Finished JSON initialization for route \(self.id)")
    }
    

    
}
extension Route:CustomStringConvertible {
    var description: String {
        return  """
                Color: \(self.color)
                Created: \(self.created)
                Description: \(self.desc)
                Enabled: \(self.enabled)
                ID: \(self.id)
                Name: \(self.name)
                Points: \(self.points)
                Stop IDs: \(self.stop_ids)
                Updated: \(self.updated)
                Width: \(self.width)
                """
    }
}

// Fetches route data from shuttles.rpi.edu/routes and writes it
// to routes.json in the application's documents directory.
// Returns a String containing the raw JSON data fetched.
func fetchRoutes() -> String {
    /*
     TODO:
     
     dataTask returns all the information in Data object,
     figure out how to use JSONSerialization with a Data object
     Maybe have to create a struct with the certain format of the JSON?
     Working with NSArray instead of a parsed [String: Any] Dictionary????
     */

    let urlString = URL(string: "https://shuttles.rpi.edu/routes")
    let semaphore = DispatchSemaphore(value: 0)
    var routesData = ""
    if let url = urlString {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let usableData = data {
                    let dataString = String(data: usableData, encoding: .utf8)!
                    writeJSON(filename: "routes.json", data: dataString)
                    routesData = dataString
                    semaphore.signal()
                }
            }
        }
        task.resume()
        semaphore.wait()
    }
    return routesData
}

// Initializes routes from routes.json if it exists, otherwise will
// fetch route data and write it to routes.json before returning an
// array of the routes.
func initRoutes() -> [Route] {
    var routes:[Route] = []
    let file = "routes.json"
    let dataString = !fileExists(filename: file) ? fetchRoutes() : readJSON(filename: file)
    let data = dataString.data(using: .utf8)!
    let json = try? JSONSerialization.jsonObject(with: data, options: []) as! NSArray
    for unique in json! {
        print("Creating new route...")
        let route = Route(json:unique as! NSDictionary)
        print(route!)
        routes.append(route!)
    }
    
    return routes
}
