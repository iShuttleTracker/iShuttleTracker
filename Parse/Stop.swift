//
//  Stop.swift
//  ShuttleTrackeriOS
//
//  Created by Matt Czyr on 10/4/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

struct Stop {
    
    var id = 0
    var latitude = 0.0
    var longitude = 0.0
    var created = ""
    var updated = ""
    var name = ""
    var desc = ""
    
    init?(json: NSDictionary) {
        // Catch stop data
        for (key, value) in json {
            switch key as? NSString {
            case "id":
                self.id=(value as! Int)
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
            case "desc":
                self.desc = (value as! String)
            default:
                // This should never happen
                print("\(key)")
            }
        }
        print("Finished JSON initialization for stop \(self.id)")
    }
    
    
}

extension Stop: CustomStringConvertible{
    var description: String{
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

func fetchStops() -> [Stop] {
    var stops:[Stop] = [];
    let urlString = URL(string: "https://shuttles.rpi.edu/stops")
    
    if let url = urlString {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let usableData = data {
                    let json = try? JSONSerialization.jsonObject(with: usableData, options: []) as! NSArray
                    
                    for unique in json! {
                        print("Creating new stop...")
                        let stop = Stop(json:unique as! NSDictionary)
                        print(stop!)
                        stops.append(stop!)
                    }
                }
            }
        }
        task.resume()
    }
    
    return stops
}
