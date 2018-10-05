//
//  route.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/26/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

struct Route {
    
    var color = ""
    var created = ""
    var desc = ""
    var enabled = false
    var id = 0
    var name = ""
    var points: [Point] = []
    var stop_ids: [Int] = []
    var updated = ""
    var width = 0
    
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
                self.desc = (value as! String)
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
extension Route:CustomStringConvertible{
    var description: String{
        return  """
                  Color: \(self.color)
                  Created: \(self.created)
                  Description: \(self.desc)
                  Enabled: \(self.enabled)
                  ID: \(self.id)
                  Name: \(self.name)
                  Points: \(self.points)
                  Stop IDs: \(self.stop_ids)
                  Updated: \(self.updated)
                  Width: \(self.width)
                  """
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
            print(r!)
            routes.append(r!)
            // differentRoutes.append(Route(json:(unique as! NSDictionary))!);
        }
    }
    
    // keep it running when it's done
    task.resume()
    
    return routes
    
}
