//
//  route.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/26/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

/*
 Route struct:
 color: String
 created: String (time object)
 description: String
 enabled: Bool (int rep)
 id: Int
 name: String
 points: Array:
    latitude: Double
    longitude: Double
 stop_ids: Ints? (empty)
 updated: String (time object)
 width: Int
 
 ^^ order in which webpage displays it
 */

struct Route{
    
    //default init
    var color = "";
    var created = "";
    var description = "";
    var enabled = false;
    var id = 0;
    var name = "";
    var points: [Point] = [];
    var stop_ids: [Int] = [];
    var updated = "";
    var width = 0;
    
    
    func routeInfo(){
        print("Color: \(self.color)");
        print("Created: \(self.created)");
        print("Description: \(self.description)");
        print("Enabled: \(self.enabled)");
        print("Id: \(self.id)");
        print("Name: \(self.name)");
        
        //create a prettier way of printing the points
        print("Points: \(self.points)");
        //--------------------------------
        
        print("Stop_IDs: \(self.stop_ids)");
        print("Updated: \(self.updated)");
        print("Width: \(self.width)");
    }
}
