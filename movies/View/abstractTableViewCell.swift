//
//  abstractTableViewCell.swift
//  movies
//
//  Created by Ahmed Salah on 12/18/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

import UIKit

class abstractTableViewCell: UITableViewCell {

    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessibilityIdentifier = "abstract"
    }
    func setCell(title: String, date: String, image: UIImage){
        self.movieTitle.text=title
        self.releaseDate.text=String("Release date: \(date)")
        self.preview.image=image
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
