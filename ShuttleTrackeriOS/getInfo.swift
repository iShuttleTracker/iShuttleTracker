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
    
     */
    
    let task = URLSession.shared.dataTask(with: urlRequest){
        toParse, response, error in
        guard toParse != nil else { return }
        
        let json = try? JSONSerialization.jsonObject(with: toParse!, options: []);
        print(json);
        
        let route = Route();
//        print("\(response) anddddd \(type(of: toParse))");c
//
//        let contents = String(data:toParse!, encoding: .ascii);
//
//        print(contents);
    }
    
    //keep it running when it's done
    task.resume()

}
