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
    
    let address = URL(string: "https://shuttles.rpi.edu/vehicles")!;
    
    let urlRequest = URLRequest(url: address);
    
    /*
     TODO:
     
     dataTask returns all the information in Data object,
     
     figure out how to use JSONSerialization with a Data object
     
     Maybe have to create a struct with the certain format of the JSON?
    
     */
    
    let task = URLSession.shared.dataTask(with: urlRequest){
        data, response, error in
        guard data != nil else { return }
        print("\(response) anddddd \(type(of: data))");
        let contents = String(data:data!, encoding: .ascii);
    }
    
    //keep it running when it's done
    task.resume()

}
