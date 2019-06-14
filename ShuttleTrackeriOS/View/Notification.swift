//
//  Trip.swift
//  ShuttleTrackeriOS
//
//  Created by Enzhe Lu on 6/7/19.
//  Copyright © 2019 WTG. All rights reserved.
//

import Foundation
import UIKit


let stopName = ["Student Union","Troy Building Crosswalk","Sage","West Hall","9th and Sage","Blitman Residence Commons","15th and College Ave.","13th and Peoples Ave.","Colonie Apartments","Brinsmade Terrace","Sunset Terrace","Polytechnic Residence Commons","6th Ave. and City Station","BARH","Winslow","E Lot"]

class Notification: UIViewController{

    @IBOutlet weak var beginStop: UIPickerView!
    @IBOutlet weak var endStop: UIPickerView!
    @IBOutlet weak var targetArrivalTime: UIDatePicker! 
    
    
    var beginStopName = "Student Union"
    var endStopName = "Student Union"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.beginStop.dataSource = self
        self.beginStop.delegate = self
        self.endStop.dataSource = self
        self.endStop.delegate = self
    }

    @IBAction func timeDidChanged(_ sender: Any) {
        
        print(targetArrivalTime.date)
        
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
