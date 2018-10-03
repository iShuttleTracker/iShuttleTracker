//
//  parsing.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/26/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

//json initialization
//automatically read in Route object given the JSON file
extension Route{
    
    init?(json: NSDictionary){
        //need to add the points to the route
        var pointsList:[Point] = [];
        //for each different route
            
            //for each different value of each route
            for (left, key) in json{
                switch left as? NSString{
                    
                    //catching different variables for a route
                    case "color":
                        self.color=(key as! String);
                    case "created":
                        self.created=(key as! String);
                    case "description":
                        self.description=(key as! String);
                    case "enabled":
                        self.enabled=(key as! Bool);
                    case "id":
                        self.id=(key as! Int);
                    case "name":
                        self.name=(key as! String);
                    case "stop_ids":
                        self.stop_ids=(key as! [Int]);
                    case "updated":
                        self.updated=(key as! String);
                    case "width":
                        self.width=(key as! Int);
                    case "points":
                        
                        //need to parse the coordinates separately since
                        //nested dictionary inside a dictionary
                        for loc in (key as! NSArray){
                            var lat: Double=0;
                            var long: Double=0;
                            for piece in (loc as! NSDictionary){
                                if((piece.key as! String) == "latitude"){ lat = piece.value as! Double; }
                                else { long = piece.value as! Double; }
                            }
                            //append the points to the array
                            pointsList.append(Point(latitude: lat, longitude: long));
                        }
                    default:
                        //should never go off
                        print("\(left)");
                }
            }
            //points set at the end
            self.points=pointsList;
            print("finished json init");
        }
    
}
