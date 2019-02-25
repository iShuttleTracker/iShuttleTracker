//
//  schedule.swift
//  
//
//  Created by zrysnd on 2019/2/1.
//

import Foundation

//read from a file and return a string for the whole file
func readDataFromFile(file:String) -> String!{
    guard let filePath = Bundle.main.path(forResource: file, ofType: "csv")
        else{
            return nil
    }
    do {
        
        let contents = try String(contentsOfFile: filePath, encoding: .utf8)
        return contents
    } catch {
        print("File Read Error for file \(filePath)")
        return nil
    }
}

func parseString(dataRead:String)->[String]{
    let parsed = dataRead.components(separatedBy: .newlines)
    return parsed
}

//@Para an int 0-3, corresponding to 4 schedules:"MFEast", "MFEastExpress", "weekendEast", "weekendLateNighEeast"
//return schedule, an array of arrays, first array contains locations
//for i >=1, within range, schedule[i] is all times for stop at one location.
// if Drop at Union only, first location has the string, other locations behind it has an empty string.
// if a stop is "X", "X" will appear in the array.
func getSchedule(sheet:Int)->[[String]]{
    let sheets = ["MFE", "MFEP", "weekendE", "weekendLNE","MFW","SaW","SuW"]
    let file = sheets[sheet]
    let tmp = readDataFromFile(file:file)
    var t = parseString(dataRead:tmp!)
    var index = 0
    while index < t.count {
        if t[index] == "" { //remove empty lines
            t.remove(at: index) //this will cause array index out of range
            index = index-1
        }
        index = index+1
    }
    
    var i = 0
    while !t[i].contains("Union,"){
        i = i+1
    }
    let locations = t[i].components(separatedBy: ",")
    var schedule = [[String]]()
    schedule.append(locations)
    
    // make schdule a 2D array
    i=0
    while i<locations.count{
        schedule.append([String]())
        i = i+1
    }
    
    //add locations to the first element each array of times
    i = 0
    while( i < locations.count){
        schedule[i+1].append(locations[i])
        i = i+1
    }
    
    // put time data into schedule
    i = 0
    while i < t.count{
        if t[i].contains(":"){
            let times = t[i].components(separatedBy: ",")
            var j = 1 // the first array is locations.
            for time in times{
                schedule[j].append(time)
                j = j+1
            }
        }
        i = i+1
    }
    return schedule
}
