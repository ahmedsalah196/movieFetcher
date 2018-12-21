//
//  deatailsTableViewCell.swift
//  movies
//
//  Created by Ahmed Salah on 12/18/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

import UIKit

class deatailsTableViewCell: UITableViewCell,UITextViewDelegate {

    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var preview: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setCell(title:String, date:String, text : String, image: UIImage){
        self.title.text = String("Title: \(title)")
        self.date.text = String("Release date: \(date)")
        self.preview.image = image
        overview.text = text
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
