//
//  StopParsing.swift
//  ShuttleTrackeriOS
//
//  Created by Matt Czyr on 10/4/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

// Read in Stop object given the JSON data
extension Stop {
    
    init?(json: NSDictionary) {
        // Catch stop data
        for (key, value) in json {
            switch key as? NSString {
            case "id":
                self.id=(value as! Int)
            case "latitude":
                self.latitude=(value as! Double)
            case "longitude":
                self.longitude=(value as! Double)
            case "created":
                self.created=(value as! String)
            case "updated":
                self.updated=(value as! String)
            case "name":
                self.name=(value as! String)
            case "description":
                self.description=(value as! String)
            default:
                // This should never happen
                print("\(key)")
            }
        }
        print("Finished JSON initialization for stop \(self.id)")
    }
    
}
