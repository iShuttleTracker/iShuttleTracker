//
//  Trip.swift
//  ShuttleTrackeriOS
//
//  Created by Enzhe Lu on 6/7/19.
//  Copyright © 2019 WTG. All rights reserved.
//

import Foundation
import UIKit


var stopName = ["Student Union","Troy Building Crosswalk","Sage","West Hall","9th and Sage","Blitman Residence Commons","15th and College Ave.","13th and Peoples Ave.","Colonie Apartments","Brinsmade Terrace","Sunset Terrace","Polytechnic Residence Commons","6th Ave. and City Station","BARH","Winslow","E Lot"]
var eastRoute = ["Union","Colonie","Brinsmade","Sunset 1 & 2","E-lot","B-lot","13th/Peop.","9th/Sage","Winslow","West lot","Sage Ave","Union"]

class Notification: UIViewController{

    @IBOutlet weak var beginStop: UIPickerView!
    @IBOutlet weak var endStop: UIPickerView!
    @IBOutlet weak var targetArrivalTime: UIDatePicker!
    @IBOutlet weak var submit: UIButton!
    
    var beginStopName = "Union"
    var endStopName = "Union"
    var minute = ""
    var second = ""
    var data = ""
    var csvRowsEast630a:[[String]] = [[]]
    var csvRowsEast8a:[[String]] = [[]]
    var csvRowsEast245p:[[String]] = [[]]
    var csvRowsEast430p:[[String]] = [[]]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func WestClick(_ sender: Any) {
        data = readDataFromCSV(fileName: "MFW", fileType: "csv")
        data = cleanRows(file: data)

        self.beginStop.dataSource = self
        self.beginStop.delegate = self
        self.endStop.dataSource = self
        self.endStop.delegate = self

    }
    @IBAction func EastClick(_ sender: Any) {
        // prepare the datasets when you click the button
        // read the four csv files
        data = readDataFromCSV(fileName: "630AM-3PM", fileType: "csv")
        data = cleanRows(file: data)
        csvRowsEast630a = csv(data: data)
        data = readDataFromCSV(fileName: "8AM-430PM", fileType: "csv")
        data = cleanRows(file: data)
        csvRowsEast8a = csv(data: data)
        data = readDataFromCSV(fileName: "245PM-1115PM", fileType: "csv")
        data = cleanRows(file: data)
        csvRowsEast245p = csv(data: data)
        data = readDataFromCSV(fileName: "430PM-830PM", fileType: "csv")
        data = cleanRows(file: data)
        csvRowsEast430p = csv(data: data)
        stopName = eastRoute
        // set the datasource and delegate of beginSTop and endStop
        self.beginStop.dataSource = self
        self.beginStop.delegate = self
        self.endStop.dataSource = self
        self.endStop.delegate = self
    }
    
    ///////////// Three supporting data reading functions //////////////////////
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    /////////////////////////////////////////////////////////////////////////////
    
    @IBAction func timeDidChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        self.minute = dateFormatter.string(from: self.targetArrivalTime.date)
        dateFormatter.dateFormat = "mm"
        self.second = dateFormatter.string(from: self.targetArrivalTime.date)
    }
    
    func creatAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true, completion: nil)
    }
    
    func findTargetEndStop(csvRows:[[String]], beginIndex:Int, endIndex:Int) ->
        [Date] {
        let date = Date()
        let calendar2 = Calendar.current
        let year = calendar2.component(.year, from: date)
        let month = calendar2.component(.month, from: date)
        let day = calendar2.component(.day, from: date)

        for index in 2...(csvRows.count-1){
            
            if (csvRows[index][0] == "") || (csvRows[index][0] == "Union") {
                continue
            }
            
            let someDateTime = timeToIndex(csvRows: csvRows,row: index,col: endIndex,year: year,month: month,day: day)

            if someDateTime >= targetArrivalTime.date {
                // the index you get is the first time after customer's target arrival time
                if index == 2{
                    return []
                }
                let beginTime = timeToIndex(csvRows: csvRows,row: index-1,col: beginIndex,year: year,month: month,day: day)
                let endTime = timeToIndex(csvRows: csvRows,row: index-1,col: endIndex,year: year,month: month,day: day)
                return [beginTime,endTime]
            }
            
        }
        return []
    }
    
    func timeToIndex(csvRows:[[String]],row:Int,col:Int,year:Int,month:Int,day:Int) -> Date{
        let lastWord = csvRows[row][col].last
        let restWord = csvRows[row][col].dropLast()
        let timeArr = restWord.split{$0 == ":"}.map(String.init)
        print(restWord)
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = Int(timeArr[0])
        if (lastWord == "p") || (lastWord == "P") { // if it is pm, then tranform it to be 24-hour system. both P and p are existed
            if (Int(timeArr[0]) != 12) {
               dateComponents.hour = Int(timeArr[0])!+12
            }
        }
        dateComponents.minute = Int(timeArr[1])
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        return userCalendar.date(from: dateComponents) ?? targetArrivalTime.date
        
    }
    
    @IBAction func submitRequest(_ sender: Any) {
        let date = Date()
        if beginStopName == endStopName {
            creatAlert(title: "Warning", message: "You entered same begin and end stop name!")
        }
        else if targetArrivalTime.date < date {
            creatAlert(title: "Warning", message: "You entered a time that has passed!")
        }
        else{
            var endTime = Date()
            var beginTime = Date()
            let csvList = [csvRowsEast630a,csvRowsEast8a,csvRowsEast245p,csvRowsEast430p]
            let beginIndex = beginStop.selectedRow(inComponent: 0)
            let endIndex = endStop.selectedRow(inComponent: 0)
            
            for csv in csvList {
                var index = findTargetEndStop(csvRows: csv, beginIndex: beginIndex, endIndex: endIndex)
                print(index)
                if index.count > 0 { // ignore all the cases that haven't found any bus solutions
                    if index[1] > endTime{
                        endTime = index[1]
                        beginTime = index[0]
                        continue
                    }
                }
            }
            
           let currentDateTime = Date()
            if beginTime < currentDateTime {
                creatAlert(title: "Error", message: "You can never make it!!!")
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            creatAlert(title: "Warning", message: "endstop: " + formatter.string(from: endTime) + "\n" + "beginstop: " + formatter.string(from: beginTime))
        }
    }
}



extension Notification: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stopName.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stopName[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{
            beginStopName = stopName[row]
        }
        else if pickerView.tag == 1{
            endStopName = stopName[row]
        }
    }
}
