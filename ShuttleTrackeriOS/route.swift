//
//  route.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/26/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation


struct Route{
    
    let id: Int;
    let name: String;
    let description: String;
    let enabled: Bool;
    let color: String;
    let width: Int;
    let stopIDs: [Int]?;
    let created: Int; //need to make time.Time for this
    let updated: Int; //need to make time.Time for this
    let points: [Point];
//
    init(){
        self.id=1;
        self.name="asdf";
        self.description="asdf";
        self.enabled=false;
        self.color="Black";
        self.width=1;
        self.stopIDs=[1,2,3];
        self.created=10;
        self.updated=10;
        self.points=[Point()];
    }
    
}
