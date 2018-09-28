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
    
    var color: String;
    var created: String;
    var description: String;
    var enabled: Bool;
    var id: Int;
    var name: String;
    var points: [Point];
    var stop_ids: [Int];
    var updated: String;
    var width: Int;
    
//
//    init(){
//        self.id=1;
//        self.name="asdf";
//        self.description="asdf";
//        self.enabled=false;
//        self.color="Black";
//        self.width=1;
//        self.stop_ids=[1,2,3];
//        self.created="10";
//        self.updated="10";
//        self.points=[Point()];
//    }
    
    //to add points to
    mutating func addPoint(p: Point){
        self.points.append(p);
    }
    
}
