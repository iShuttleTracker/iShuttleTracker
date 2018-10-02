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
    
}

func fetchVehicles() {
    var vehicles:[Vehicle] = [];
    let urlString = URL(string: "https://shuttles.rpi.edu/vehicles")
    
    if let url = urlString {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                if let usableData = data {
                    // TODO: Use JSONSerialization to create Vehicles from the usableData and add them to the vehicles array
                    print(String(data: usableData, encoding: .utf8)!)
                }
            }
        }
        task.resume()
    }
}
