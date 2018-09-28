//
//  getInfo.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/20/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

func vehicleInformation(){
    
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
    
    let task = URLSession.shared.dataTask(with: urlRequest){
        toParse, response, error in
        guard toParse != nil else { return }
        
        let json = try? JSONSerialization.jsonObject(with: toParse!, options: []) as! NSArray;
//        print(json);
//        print(type(of: json));
        for tempobject in json!  {
            let tempobject = tempobject as! NSDictionary;
            for (id, key) in tempobject{
        
                //need to cast id to NSString since it's an Any object
                if((id as? NSString) == NSString(string: "points")){
                    print("Loop through lat and long here, NSArray");
                }
            }
//            for id in tempobject{
//                NSLog("\(id)");
//            }
        }
//        let route = Route(json: NSArray);
        
//        let route = Route(json: json!);
//        print("\(response) anddddd \(type(of: toParse))");c
//
//        let contents = String(data:toParse!, encoding: .ascii);
//
//        print(contents);
    }
    
    //keep it running when it's done
    task.resume()

}
