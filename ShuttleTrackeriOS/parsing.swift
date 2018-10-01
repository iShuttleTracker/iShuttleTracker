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
    
    init?(json: NSArray){
        var points:[Point] = [];
        //for each different route
        for field in json{
            
            //for each different value of each route
            for (id, key) in field as! NSDictionary{
                switch id as? NSString{
                    
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
                        for loc in (key as! NSArray){
                            var lat: Double=0;
                            var long: Double=0;
                            for piece in (loc as! NSDictionary){
                                if((piece.key as! String) == "latitude"){
                                    lat=piece.value as! Double;
                                }
                                else{
                                    long = piece.value as! Double;
                                }
                            }
                            print("\(lat)   \(long)");
                            points.append(Point(latitude: lat, longitude: long));
                            
                        }
                    default:
                        //should never go off
                        print("\(id)");
                    
                }
                
            }
            
            print("finished json init");
        }
//        var points: [Point]=[];
//        for string in pointsJSON{
//            print(string);
//            //            guard let point = Point(latitude: Double, longitude: Double)
//            //                else{
//            //                    return nil;
//            //            }
//        }
        
        self.points = [];
        
        self.color = "a";
        self.created = "a";
        self.description = "a";
        self.enabled = false;
        self.id = 1;
        self.name = "asdf";
        self.stop_ids=[];
        self.updated="a";
        self.width=1;
    }
        /*
        guard let color = json["color"] as? String,
        let created = json["created"] as? String,
        let description = json["description"] as? String,
        let enabled = json["enabled"] as? Bool,
        let id = json["id"] as? Int,
        let name = json["name"] as? String,
        let pointsJSON = json["points"] as? [Double:Double],
        let stop_ids = json["stop_ids"] as? [Int],
        let updated = json["updated"] as? String,
        let width = json["width"] as? Int
       
        
        
        
        else{
            return nil;
        }
        var points: [Point]=[];
        for string in pointsJSON{
            print(string);
//            guard let point = Point(latitude: Double, longitude: Double)
//                else{
//                    return nil;
//            }
        }
        
        self.points = points;
        
        self.color = color;
        self.created = created;
        self.description = description;
        self.enabled = enabled;
        self.id = id;
        self.name = name;
        self.stop_ids=stop_ids;
        self.updated=updated;
        self.width=width;
        
        
        
        
    }
    
    */
    
}
