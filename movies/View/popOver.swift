//
//  popOver.swift
//  movies
//
//  Created by Ahmed Salah on 12/19/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

import UIKit

class popOver: UIViewController {

    
    var tit: String!
    var dat:String!
    var img: UIImage!
    
    var tablecontroller: moviesTableViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
    }
    
    @IBAction func closePopup(_ sender: Any) {
        self.removeAnimate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    func nextPop(popOverVC: popOver){
        self.removeAnimate()
        tablecontroller.addChildViewController(popOverVC)
        popOverVC.view.frame = tablecontroller.view.frame
        tablecontroller.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: tablecontroller)
    }
    
}
