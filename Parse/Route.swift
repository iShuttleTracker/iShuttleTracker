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

struct Route {
    
    //default init
    var color = ""
    var created = ""
    var description = ""
    var enabled = false
    var id = 0
    var name = ""
    var points: [Point] = []
    var stop_ids: [Int] = []
    var updated = ""
    var width = 0
    
    
    func printRoute(){
        print("Color: \(self.color)")
        print("Created: \(self.created)")
        print("Description: \(self.description)")
        print("Enabled: \(self.enabled)")
        print("Id: \(self.id)")
        print("Name: \(self.name)")
        printPoints()
        print("Stop_IDs: \(self.stop_ids)")
        print("Updated: \(self.updated)")
        print("Width: \(self.width)")
    }
    
    func printPoints() {
        for i in 0...self.points.count - 1 {
            print("Point #\(i):")
            self.points[i].printPoint()
        }
    }
}

func fetchRoutes() -> [Route] {
    // The URL
    let address = URL(string: "https://shuttles.rpi.edu/routes")!
    let urlRequest = URLRequest(url: address)
    
    /*
     TODO:
     
     dataTask returns all the information in Data object,
     figure out how to use JSONSerialization with a Data object
     Maybe have to create a struct with the certain format of the JSON?
     Working with NSArray instead of a parsed [String: Any] Dictionary????
     
     */
    
    var routes:[Route] = []
    let task = URLSession.shared.dataTask(with: urlRequest) {
        toParse, response, error in
        guard toParse != nil else { return }
        let json = try? JSONSerialization.jsonObject(with: toParse!, options: []) as! NSArray
        
        // For each route, initialize a new route with the parameters in the unique dic
        for unique in json! {
            print("Creating new route...")
            let r = Route(json:unique as! NSDictionary)
            r?.printRoute()
            routes.append(r!)
            // differentRoutes.append(Route(json:(unique as! NSDictionary))!);
        }
    }
    
    // keep it running when it's done
    task.resume()
    
    return routes
    
}
