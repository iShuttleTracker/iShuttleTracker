//
//  VehicleParsing.swift
//  ShuttleTrackeriOS
//
//  Created by Matt Czyr on 10/2/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

// Read in Vehicle object given the JSON data
extension Vehicle{
    
    init?(json: NSDictionary){
        // Catch vehicle data
        for (key, value) in json {
            switch key as? NSString {
            case "id":
                self.id=(value as! Int)
            case "name":
                self.name=(value as! String)
            case "created":
                self.created=(value as! String)
            case "updated":
                self.updated=(value as! String)
            case "enabled":
                self.enabled=(value as! Bool)
            case "tracker_id":
                self.tracker_id=(value as! String)
            default:
                // This should never happen
                print("\(key)")
            }
        }
        print("Finished JSON initialization for vehicle \(self.id)")
    }
    
}
