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
    
    let id: Int;
    let name: String;
    let description: String;
    let enabled: Bool;
    let color: String;
    let width: Int;
    var stopIDs: [Int]?;
    let created: String; //need to make time.Time for this
    var updated: String; //need to make time.Time for this
    var points: [Point];
//
    init(){
        self.id=1;
        self.name="asdf";
        self.description="asdf";
        self.enabled=false;
        self.color="Black";
        self.width=1;
        self.stopIDs=[1,2,3];
        self.created="10";
        self.updated="10";
        self.points=[Point()];
    }
    
    //to add points to
    mutating func addPoint(p: Point){
        self.points.append(p);
    }
    
}
