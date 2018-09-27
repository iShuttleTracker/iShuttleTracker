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
        guard let id = json["id"] as? Int,
        let color = json["color"] as? String,
        let description = json["description"] as? String,
        let enabled = json["enabled"] as? Bool,
        let created = json["created"] as? String,
        let updated = json["updated"] as? String,
        let width = json["width"] as? Int,
        let pointsJSON = json["points"] as? [Double:Double],
        let name = json["name"] as? String
        
        
        
        else{
            return nil;
        }
//        var points: [Point]=[];
//        for string in pointsJSON{
//            guard let point = Point(latitude: Double, longitude: Double)
//                else{
//                    return nil;
//            }
//        }
        
        self.id = id;
        self.name = name;
        self.description = description;
        self.enabled = enabled;
        self.width=width;
        self.stopIDs=[];
        
        
    }
    
    
    
}
