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
    
    init?(json: [String: Any]){
        print("yes");
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
    
    
    
}
