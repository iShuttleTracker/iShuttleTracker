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
//    let session = URLSession(configuration: .default);
    
//    var dataTask: URLSessionDataTask?;
    
    
    let task = URLSession.shared.dataTask(with: urlRequest){ data, response, error in
        guard data != nil else { return }
        let contents = String(data:data!,encoding: .ascii);
        print(contents);
    }
    task.resume()
    
    /*
    let task = session.dataTask(with: urlRequest){
        (data,response,error) in
        // check for any errors
        guard error == nil else {
            print("error calling GET on /todos/1")
            print(error!)
            return
        }
        // make sure we got data
        guard let responseData = data else {
            print("Error: did not receive data")
            return
        }
        // parse the result as JSON, since that's what the API provides
        do {
            guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                as? [String: Any] else {
                    print("error trying to convert data to JSON")
                    return
            }
            // now we have the todo
            // let's just print it to prove we can access it
            print("The todo is: " + todo.description)
            
            // the todo object is a dictionary
            // so we just access the title using the "title" key
            // so check for a title and print it if we have one
            guard let todoTitle = todo["title"] as? String else {
                print("Could not get todo title from JSON")
                return
            }
            print("The title is: " + todoTitle)
        } catch  {
            print("error trying to convert data to JSON")
            return
        }
        
        
    }
    */
    task.resume();

}
