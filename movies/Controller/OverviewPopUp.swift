//
//  OverviewPopUp.swift
//  movies
//
//  Created by Ahmed Salah on 12/19/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

import UIKit

class OverviewPopUp: popOver {

    @IBOutlet weak var overview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateOverViewText(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(updateOverViewText(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    @IBAction func addMovie(_ sender: Any) {
        let ovrvw = overview.text!
        removeAnimate()
        let newMovie = MovieWithPic(title: self.tit, date: self.dat, overview: ovrvw, image: self.img)
        self.tablecontroller.addUserMovie(movie: newMovie)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    @objc
    func updateOverViewText(notification: Notification){
        let userinfo = notification.userInfo!
        let kefsc = (userinfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let kef = self.view.convert(kefsc, to:view.window)
        if notification.name == Notification.Name.UIKeyboardWillHide{
            overview.contentInset = UIEdgeInsets.zero
        }
        else {
            overview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: kef.height, right: 0)
            overview.scrollIndicatorInsets = overview.contentInset
        }
        overview.scrollRangeToVisible(overview.selectedRange)
        
    }
}
