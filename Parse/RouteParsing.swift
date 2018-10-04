//
//  getInfo.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/20/18.
//  Copyright © 2018 WTG. All rights reserved.
//

//json initialization
//automatically read in Route object given the JSON file
import Foundation

extension Route {
    
    init?(json: NSDictionary) {
        //need to add the points to the route
        var pointsList:[Point] = [];

        //for each different value of each route
        for (key, value) in json {
            switch key as? NSString {
                
            //catching different variables for a route
            case "color":
                self.color = (value as! String)
            case "created":
                self.created = (value as! String)
            case "description":
                self.description = (value as! String)
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
                //need to parse the coordinates separately since
                //nested dictionary inside a dictionary
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
                    //append the points to the array
                    pointsList.append(Point(latitude: lat, longitude: long))
                }
            default:
                //should never go off
                print("\(key)")
            }
        }
        //points set at the end
        self.points = pointsList
        print("Finished JSON initialization for route \(self.id)")
    }
    
}
