//
//  CustomCollectionViewController.swift
//  ShuttleTrackeriOS
//
//  Created by zrysnd on 2019/4/12.
//  Copyright © 2019 WTG. All rights reserved.
//

import UIKit

let reuseIdentifier = "customCell"

class CustomCollectionViewController : UICollectionViewController {
    // MARK: UICollectionViewDataSource
    var i = 0
    
    let schedule = getSchedule(sheet: 5)
    
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        
        return schedule[1].count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        //        if(section == 5)
        //        {return 2}
        return schedule.count-1
        //        return section
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCollectionViewCell
        
        // Configure the cell
        //        let tmp = String(i)
        let i = Int(indexPath.section.description)
        let j = Int(indexPath.item.description)
        cell.label.text = "Sec " + indexPath.section.description + "/Item " + indexPath.item.description
        //        + "i"
        //        i = i + 1
        cell.label.text = schedule[j!+1][i!]
        
        //        let view = UIView(frame: cell.bounds)
        // Set background color that you want
        //        view.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        if(i == 2 && j == 2){
            cell.contentView.backgroundColor = UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }else{
            cell.contentView.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        return cell
    }

}

