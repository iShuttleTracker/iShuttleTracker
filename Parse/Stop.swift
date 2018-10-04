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
    var description = ""
    
    func printStop() {
        print("ID: \(self.id)")
        print("Latitude: \(self.latitude)")
        print("Longitude: \(self.longitude)")
        print("Created: \(self.created)")
        print("Updated: \(self.updated)")
        print("Name: \(self.name)")
        print("Description: \(self.description)")
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
                        stop?.printStop()
                        stops.append(stop!)
                    }
                }
            }
        }
        task.resume()
    }
    
    return stops
}
