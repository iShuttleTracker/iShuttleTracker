//
//  getInfo.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/20/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

func RouteInformation(){
    
    //the url
    
    let address = URL(string: "https://shuttles.rpi.edu/routes")!;
    
    let urlRequest = URLRequest(url: address);
    
    /*
     TODO:
     
     dataTask returns all the information in Data object,
     
     figure out how to use JSONSerialization with a Data object
     
     Maybe have to create a struct with the certain format of the JSON?
     
     Working with NSArray instead of a parsed [String: Any] Dictionary????
    
     */
    var differentRoutes:[Route] = [];
    let task = URLSession.shared.dataTask(with: urlRequest){
        toParse, response, error in
        guard toParse != nil else { return }
        
        let json = try? JSONSerialization.jsonObject(with: toParse!, options: []) as! NSArray;
        
        //for each route, initialize a new route with the parameters in the unique dic
        for unique in json! {
            print("creating new route...");
            let r = Route(json:unique as! NSDictionary);
            r?.routeInfo();
            differentRoutes.append(r!);
//            differentRoutes.append(Route(json:(unique as! NSDictionary))!);
        }
    }
    
    //keep it running when it's done
    task.resume()

}
