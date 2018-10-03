//
//  UpdateParsing.swift
//  ShuttleTrackeriOS
//
//  Created by Matt Czyr on 10/2/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

// Read in Update object given the JSON data
extension Update {
    
    init?(json: NSDictionary){
        // Catch update data
        for (key, value) in json {
            switch key as? NSString {
            case "id":
                self.id=(value as! Int)
            case "tracker_id":
                self.tracker_id=(value as! String)
            case "latitude":
                self.latitude=(value as! Double)
            case "longitude":
                self.longitude=(value as! Double)
            case "heading":
                self.heading=(value as! Int)
            case "speed":
                self.speed=(value as! Double)
            case "time":
                self.time=(value as! String)
            case "created":
                self.created=(value as! String)
            case "vehicle_id":
                self.vehicle_id=(value as! Int)
            case "route_id":
                self.route_id=(value as! Int)
            default:
                // This should never happen
                print("\(key)")
            }
        }
        print("Finished JSON initialization for update \(self.id)")
    }
    
}
