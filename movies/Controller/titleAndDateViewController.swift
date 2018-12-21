//
//  PopUpViewController.swift
//  movies
//
//  Created by Ahmed Salah on 12/19/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

import UIKit

class titleAndDateViewController: popOver {

    @IBOutlet weak var movieTitle: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    
    @IBAction func toImagePicker(_ sender: Any) {
                let imgPick = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imageid")as! imagePicker
        imgPick.tit = movieTitle.text
        
        let releaseDate = fromDateToString(date: date.date)
        imgPick.dat = releaseDate
        imgPick.tablecontroller = self.tablecontroller
        nextPop(popOverVC: imgPick)
    }
    
    //allow user to close the keyboard when touched outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func fromDateToString(date: Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        let releseDate = dateFormatter.string(from: date)
        return releseDate
    }
}
